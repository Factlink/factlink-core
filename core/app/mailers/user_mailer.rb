class UserMailer < ActionMailer::Base
  default from: "no-reply@factlink.com"

  def welcome_instructions(user)
  	@user = user
  	mail to: @user.email, subject: 'Start using Factlink'
  end

end
