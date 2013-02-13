class ActivityMailer < ActionMailer::Base
  include Resque::Mailer

  helper :activity_mailer, :fact

  layout "email"

  def new_activity(user_id, activity_id)
    @user = User.find(user_id)
    @activity = Activity[activity_id]

    mail to: @user.email,
         subject: get_mail_subject_for_activity(@activity),
         from: from
  end

  private
    def from
      env_str = ""

      if ['development', 'testserver', 'staging'].include? Rails.env
        env_str = " #{Rails.env}"
      end

      "\"Factlink#{env_str}\" <support@factlink.com>"
    end

    def get_mail_subject_for_activity activity
      case activity.action.to_sym
      when :added_subchannel
        "#{activity.user.user} added your #{activity.subject.title} #{I18n.t :channel} to their own #{activity.object.title} #{I18n.t :channel}"
      when :added_supporting_evidence, :added_weakening_evidence
        if activity.action == 'added_supporting_evidence'
          type = "supporting"
        else
          type = "weakening"
        end

        "#{activity.user.user} added #{type} evidence to a Factlink"
      when :created_conversation
        "#{activity.user.user} has sent you a message"
      when :replied_message
        "#{activity.user.user} has replied to a message"
      when :created_comment
        "#{activity.user.user} has commented on a Factlink"
      when :created_sub_comment
        "#{activity.user.user} has commented on a Factlink"
      else
        'New notification!'
      end
    end
end
