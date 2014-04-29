class SubscriptionsMailer < ActionMailer::Base
  default from: "Factlink <support@factlink.com>"

  def unsubscribe(user_id, type)
    @user = User.find(user_id)
    @type = type

    mail to: @user.email, subject: 'You have been unsubscribed'
  end

end
