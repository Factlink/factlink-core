class UserObserver < Mongoid::Observer
  def after_update(user)
  	@sending ||= {}

    if user.approved_changed? and user.approved? and not @sending[user.id] and not user.invitation_accepted_at
    	@sending[user.id] = true

      # Send mail
      user.send_welcome_instructions
    	@sending[user.id] = false
    end
  end
end
