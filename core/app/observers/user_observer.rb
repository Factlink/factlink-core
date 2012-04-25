class UserObserver < Mongoid::Observer
  def after_update(user)
  	@sending ||= {}

  	puts "baron UserObserver"
    if user.approved_changed? and user.approved? and not @sending[user.id]
    	@sending[user.id] = true

      # Send mail
      user.send_welcome_instructions
    	@sending[user.id] = false
    end
  end
end
