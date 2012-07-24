class UserObserver < Mongoid::Observer
  def after_update(user)
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
end

def update_mixpanel_for user
  mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)
  changed = false

  fields = user.changes
            .slice( *User.mixpaneled_fields.keys )
            .inject({}){|memo, (k,v)| memo[User.mixpaneled_fields[k]] = v[1]; memo }

  if fields.length > 0
    mixpanel.set_person_event user.id.to_s, fields
  end
end

def initialize_mixpanel_for user
  mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

  new_attributes = user.attributes
                    .slice( *User.mixpaneled_fields.keys )
                    .inject({}){|memo,(k,v)| memo[User.mixpaneled_fields[k].to_sym] = v; memo}

  mixpanel.set_person_event user.id.to_s, new_attributes
end
