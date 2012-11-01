module ActivityMailerHelper
  def render_mail_template_for_action(action)
    puts "Action: #{action}"
    case action.to_s
    when "added_subchannel"
      render_activity "added_subchannel"
    when "added_supporting_evidence", "added_weakening_evidence"
      render_activity "added_evidence"
    when "created_conversation"
      render_activity "created_conversation"
    when "invited"
      render_activity "invited"
    when "replied_message"
      render_activity "replied_message"
    else
      render_activity "generic"
    end
  end

  def render_activity activity
    render "activity_mailer/activities/#{activity.to_s}"
  end

  def link_to_possibly_dead_user(dead_user)
    link_to dead_user.username, user_profile_url(dead_user.username)
  end
end
