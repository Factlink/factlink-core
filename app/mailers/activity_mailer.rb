class ActivityMailer < ActionMailer::Base
  helper :activity_mailer

  layout "email_notification"

  def new_activity(user_id, activity_id)
    @user = Backend::Notifications.users_receiving(type: 'mailed_notifications')
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
      "\"#{FactlinkUI::Application.config.support_name} #{Rails.env}\" <#{FactlinkUI::Application.config.support_email}>"
    else
      "\"#{FactlinkUI::Application.config.support_name}\" <#{FactlinkUI::Application.config.support_email}>"
    end
  end

  def get_mail_subject_for_activity activity
    case activity[:action]
    when 'created_comment', 'created_sub_comment'
      factlink = activity[:fact].displaystring.strip.truncate(50)
      "Discussion on \"#{factlink}\""
    when 'followed_user'
      "#{activity[:user].name} is now following you on Factlink"
    else
      fail 'Unknown action'
    end
  end
end
