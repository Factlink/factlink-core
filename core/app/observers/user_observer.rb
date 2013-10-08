class UserObserver < Mongoid::Observer
  include Pavlov::Helpers

  def after_create user
    command :'text_search/index_user', user: user
  end

  def after_update user
    UserObserverTask.handle_changes user

    if user.changed?
      command :'text_search/index_user',
                  user: user,
                  changed: user.changed
    end
  end

  def after_destroy user
    command(:'text_search/delete_user', object: user)
  end
end

class UserObserverTask

  def self.handle_changes user
    if user.set_up_changed? and user.set_up?
      initialize_mixpanel_for user
    else
      update_mixpanel_for user
    end
  end

  private
  def self.update_mixpanel_for user
    fields = user.changes
              .slice( *User.mixpaneled_fields.keys )
              .inject({}){|memo, (k,v)| memo[User.mixpaneled_fields[k]] = v[1]; memo }

    return if fields.length == 0

    mixpanel.set_person_event user.id.to_s, fields
  end

  def self.initialize_mixpanel_for user
    new_attributes = user.attributes
                      .slice( *User.mixpaneled_fields.keys )
                      .inject({}){|memo,(k,v)| memo[User.mixpaneled_fields[k].to_sym] = v; memo}

    mixpanel.set_person_event user.id.to_s, new_attributes
  end

  def self.mixpanel
    FactlinkUI::Application.config.mixpanel.new({}, true)
  end

end

