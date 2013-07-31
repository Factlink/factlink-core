class UserObserver < Mongoid::Observer
  include Pavlov::Helpers

  def after_create user
    old_command :elastic_search_index_user_for_text_search, user
  end

  def after_update user
    UserObserverTask.handle_changes user

    if user.changed? and not (user.changed & ['username']).empty?
      old_command :elastic_search_index_user_for_text_search, user
    end
  end

  def after_destroy user
    old_command :elastic_search_delete_user_for_text_search, user
  end

end


class UserObserverTask

  def self.handle_changes user
    @sending ||= {}

    if user.approved_changed? and user.approved? and not @sending[user.id] and not user.invitation_accepted_at
      @sending[user.id] = true

      # Send mail
      user.send_welcome_instructions
      @sending[user.id] = false
    end

    if user.approved_changed? and user.approved?
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

    new_attributes[:approved_at] = DateTime.now

    mixpanel.set_person_event user.id.to_s, new_attributes
  end

  def self.mixpanel
    FactlinkUI::Application.config.mixpanel.new({}, true)
  end

end

