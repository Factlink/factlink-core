class SubscriptionsMailer < ActionMailer::Base
  default from: "#{FactlinkUI::Application.config.support_name} <#{FactlinkUI::Application.config.support_email}>"

  def unsubscribe(user_id, type)
    @user = User.find(user_id)
    @type = type

    mail to: @user.email, subject: 'You have been unsubscribed'
  end

end
