class UserMailer < ActionMailer::Base
  default from: "no-reply@factlink.com"

  def welcome_instructions(user)
  	# @set_password_url = edit_password_url(user, :reset_password_token => user.reset_password_token)

  	@user = user
  	mail to: user.email, subject: 'Start using Factlink'

  end

end
