class ActivityMailer < ActionMailer::Base
  include Resque::Mailer

  helper :activity_mailer

  layout "email_notification"

  def new_activity(user_id, activity_id)
    @user = UserNotification.users_receiving('mailed_notifications')
                            .find(user_id)
    @activity = Backend::Activities.get(activity_id: activity_id)

    return unless @user && @activity

    mail from: from,
         to: @user.email,
         subject: get_mail_subject_for_activity(@activity),
         template_name: @activity[:action]
  end

  private

  def from
    if ['development', 'staging'].include? Rails.env
      "\"Factlink #{Rails.env}\" <support@factlink.com>"
    else
      "\"Factlink\" <support@factlink.com>"
    end
  end

  def get_mail_subject_for_activity activity
    case activity[:action]
    when 'created_comment', 'created_sub_comment'
      factlink = activity[:fact].displaystring.strip.truncate(50)
      "Discussion on \"#{factlink}\""
      subject_for activity.subject.parent.fact_data
    when 'followed_user'
      "#{activity[:user].name} is now following you on Factlink"
    else
      fail 'Unknown action'
    end
  end
end
