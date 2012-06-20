class UserMailer < ActionMailer::Base
	include Resque::Mailer

  default from: "Factlink <no-reply@factlink.com>"

  def welcome_instructions(user_id)
  	@user = User.find(user_id)
  	mail to: @user.email, subject: 'Start using Factlink'
  end

end
