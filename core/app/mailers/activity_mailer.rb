class ActivityMailer < ActionMailer::Base
  include Resque::Mailer

  helper :activity_mailer, :fact

  layout "email"

  default from: "Factlink <support@factlink.com>"

  def new_activity(user_id, activity_id)
    @user = User.find(user_id)
    @activity = Activity[activity_id]

    mail to: @user.email, subject: 'New notification!'
  end
end
