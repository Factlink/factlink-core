class UserMailer < ActionMailer::Base
	include Resque::Mailer

  default from: "no-reply@factlink.com"

  def welcome_instructions(user)
  	@user = user
  	mail to: @user.email, subject: 'Start using Factlink'
  end

end
