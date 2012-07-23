class UserObserver < Mongoid::Observer
  def after_update(user)
  	@sending ||= {}

    if user.approved_changed? and user.approved? and not @sending[user.id] and not user.invitation_accepted_at
    	@sending[user.id] = true

      # Send mail
      user.send_welcome_instructions
    	@sending[user.id] = false
    end

    update_mixpanel_for user
  end
end

def update_mixpanel_for user
  mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)
  changed = false

  fields = user.changes.slice( *User.mixpaneled_fields )

  fields.each { |key, values| fields[key] = values[1] }

  if fields.length > 0
    mixpanel.set_person_event user.id, fields
  end
end
