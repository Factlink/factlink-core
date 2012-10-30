class ActivityMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "Factlink <support@factlink.com>"

  def new_activity(user, activity)
    mail to: user.email, subject: 'New notification!'
  end
end
