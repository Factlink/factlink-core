module ActivityMailerHelper
  def render_mail_template_for_action(action)
    render_activity mail_template_for_action(action)
  end

  def mail_template_for_action(action)
    action_string = action.to_s

    case action_string
    when "created_fact_relation", "created_comment"
      "added_argument"
    when "created_conversation", "replied_message", "created_sub_comment", "followed_user"
      action_string
    else
      fail 'Unknown action in ActivityMailer: ' + action_string
    end
  end

  def render_activity activity
    render "activity_mailer/activities/#{activity.to_s}"
  end

  def link_to_possibly_dead_user(dead_user, options={})
    link_to dead_user.name, user_profile_url(dead_user.username), options
  end
end
