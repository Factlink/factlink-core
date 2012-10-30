class ActivityMailer < ActionMailer::Base
  include Resque::Mailer

  layout "email"

  default from: "Factlink <support@factlink.com>"

  def new_activity(user, activity)
    @user = user
    @activity = activity

    mail to: user.email, subject: 'New notification!'
  end
end
