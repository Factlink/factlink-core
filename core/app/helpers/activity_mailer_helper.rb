module ActivityMailerHelper
  def render_mail_template_for_action(action)
    render_activity mail_template_for_action(action)
  end

  def mail_template_for_action(action)
    case action.to_s
    when "added_subchannel"
      "added_subchannel"
    when "added_supporting_evidence", "added_weakening_evidence"
      "added_evidence"
    when "created_conversation"
      "created_conversation"
    when "invited"
      "invited"
    when "replied_message"
      "replied_message"
    when "created_comment"
      "created_comment"
    else
      "generic"
    end
  end

  def render_activity activity
    render "activity_mailer/activities/#{activity.to_s}"
  end

  def link_to_possibly_dead_user(dead_user)
    link_to dead_user.username, user_profile_url(dead_user.username)
  end
end
