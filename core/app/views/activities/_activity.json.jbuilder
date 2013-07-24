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
  when "added_supporting_evidence", "added_weakening_evidence"
    supporting_or_weakening = (action == "added_supporting_evidence") ? :supporting : :weakening

    json.action             :added
    json.evidence           subject.to_s
    json.evidence_url       friendly_fact_path(subject)
    json.fact_url           friendly_fact_path(object)
    json.target_url         friendly_fact_with_opened_tab_path object, supporting_or_weakening
    json.type               supporting_or_weakening
    json.fact_displaystring truncate(object.data.displaystring.to_s, length: 48)

    if showing_notifications
      json.fact truncate("#{object}", length: 85, separator: " ")
    else
      json.fact { |j| j.partial! 'facts/fact', fact: object }
    end

  when "created_comment"
    supporting_or_weakening = (subject.type == "believes") ? :supporting : :weakening

    json.action             :created_comment
    json.target_url         friendly_fact_with_opened_tab_path object, supporting_or_weakening
    json.fact_displaystring truncate(object.data.displaystring.to_s, length: 48)

    if showing_notifications
      json.fact truncate("#{object}", length: 85, separator: " ")
    else
      json.fact { |j| j.partial! 'facts/fact', fact: object }
    end

  when "created_sub_comment"
    supporting_or_weakening = subject.type

    json.action       :created_sub_comment
    json.target_url   friendly_fact_with_opened_tab_path object, supporting_or_weakening
    json.fact_displaystring truncate(object.data.displaystring.to_s, length: 48)

    if showing_notifications
      json.fact truncate("#{object}", length: 85, separator: " ")
    else
      json.fact { |j| j.partial! 'facts/fact', fact: object }
    end

  when "added_subchannel"
    subject_creator_graph_user = subject.created_by
    subject_creator_user = subject_creator_graph_user.user

    json.channel_title             subject.title
    json.channel_slug_title        subject.slug_title
    json.channel_url               channel_path(subject_creator_user, subject.id)

    json.to_channel_id             object.id
    json.to_channel_title          object.title
    json.to_channel_slug_title     object.slug_title
    json.to_channel_url            channel_path(object.created_by.user, object.id)

    json.to_channel_containing_channel_ids old_query(:containing_channel_ids_for_channel_and_user, channel_id: object.id, graph_user_id: current_user.graph_user.id)

    json.target_url                channel_path(object.created_by.user, object.id)
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
  when "added_first_factlink"
    json.fact { |j| j.partial! 'facts/fact', fact: subject}
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
  when "invites"
    json.target_url user_profile_path(user)
  end
end
