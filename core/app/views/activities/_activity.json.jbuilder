subject = activity.subject
object = activity.object
action = activity.action
created_at = activity.created_at
user =  activity.user.user

json.subject_class subject.class.to_s


json.user {|j| j.partial! 'users/user_partial', user: user }

json.action action

json.translated_action t("fact_#{action.to_s}_action".to_sym)

json.subject subject.to_s

json.time_ago TimeFormatter.as_time_ago(created_at.to_time)

json.id activity.id

json.activity do |json|

  case action
  when "created_fact_relation"
    json.action             :added
    json.evidence           subject.to_s
    json.fact_url           friendly_fact_path(object)
    json.target_url         friendly_fact_path(object)
    json.fact_displaystring truncate(object.data.displaystring.to_s, length: 48)

    if showing_notifications
      json.fact truncate("#{object}", length: 85, separator: " ")
    else
      json.fact { |j| j.partial! 'facts/fact', fact: object }
    end

  when "created_comment"
    json.action             :created_comment
    json.target_url         friendly_fact_path(object)
    json.fact_displaystring truncate(object.data.displaystring.to_s, length: 48)

    if showing_notifications
      json.fact truncate("#{object}", length: 85, separator: " ")
    else
      json.fact { |j| j.partial! 'facts/fact', fact: object }
    end

  when "created_sub_comment"
    json.action       :created_sub_comment
    json.target_url   friendly_fact_path(object)
    json.fact_displaystring truncate(object.data.displaystring.to_s, length: 48)

    if showing_notifications
      json.fact truncate("#{object}", length: 85, separator: " ")
    else
      json.fact { |j| j.partial! 'facts/fact', fact: object }
    end

  when "created_channel"
    topic = subject.topic
    json.topic_title               topic.title
    json.topic_url                 topic_path(topic.slug_title)

    json.created_channel_definition t(:created_user_topic)
  when "added_fact_to_channel" # TODO: rename actual activity to added_fact_to_topic
    json.partial! 'activities/added_fact_to_topic_activity',
        subject: subject,
        object: object,
        user: user
  when "believes", "doubts", "disbelieves"
    if showing_notifications
      json.action action

      json.translated_action case action
        when 'believes'
          t(:fact_believe_past_singular_action_about)
        when 'disbelieves'
          t(:fact_disbelieve_past_singular_action_about)
        when 'doubts'
          t(:fact_doubt_past_singular_action_about)
        end


      if subject.class.to_s == "Fact"
        json.fact_path friendly_fact_path subject
        json.subject truncate("#{subject}", length: 85, separator: ' ')
      elsif subject.class.to_s == "FactRelation"
        json.fact_path friendly_fact_path subject.from_fact
        json.subject truncate("#{subject.from_fact}", length: 85, separator: ' ')
      end
    else
      json.fact { |j| j.partial! 'facts/fact', fact: subject}
    end

  when "created_conversation"
    json.target_url conversation_path(subject)

    json.message do |message|
      message.content truncate("#{subject.messages.first.content}", length: 85, separator: ' ')
    end

  when "replied_message"
    json.target_url conversation_message_path(subject.conversation, subject)

    json.message do |message|
      message.content truncate("#{subject.content}", length: 85, separator: ' ')
    end
  when "followed_user"
    json.target_url user_profile_path(user.username)
    json.followed_user do |followed_user|
      followed_user.partial! 'users/user_partial', user: subject.user
    end
  end
end
