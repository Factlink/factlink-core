class UserMailer < ActionMailer::Base
	include Resque::Mailer

  default from: "no-reply@factlink.com"

  def welcome_instructions(email, reset_password_token)
  	@email                = email
  	@reset_password_token = reset_token
  	mail to: @email, subject: 'Start using Factlink'
  end

end
