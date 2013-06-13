module ActivityMailerHelper
  def render_mail_template_for_action(action)
    render_activity mail_template_for_action(action)
  end

  def mail_template_for_action(action)
    action_string = action.to_s

    case action_string
    when "added_supporting_evidence", "added_weakening_evidence"
      "added_evidence"
    when "added_subchannel", "created_conversation",
         "replied_message", "created_comment", "created_sub_comment",
         "followed_user"
      action_string
    else
      "generic"
    end
  end

  def render_activity activity
    render "activity_mailer/activities/#{activity.to_s}"
  end

  def link_to_possibly_dead_user(dead_user)
    link_to dead_user.name, user_profile_url(dead_user.username)
  end
end
