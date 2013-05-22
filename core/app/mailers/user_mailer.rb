class UserMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "Factlink <support@factlink.com>"

  def welcome_instructions(user_id, opts={})
    @user = User.find(user_id)
    mail to: @user.email, subject: 'Start using Factlink'
  end

  # TODO: Remove me when done developing
  def discussion(fact_id)
    @fact = Fact[fact_id]

    mail to: 'tom@factlink.com', subject: 'Discussion of the Week'
  end

end
