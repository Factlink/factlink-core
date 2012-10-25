subject = activity.subject
object = activity.object
action = activity.action
created_at = activity.created_at
user =  activity.user.user

json.username user.username

json.subject_class subject.class.to_s


size = 24

json.user_profile_url user_profile_path(user)
json.avatar image_tag(user.avatar_url(size: size), width: size, height: size, alt:'')

json.action action
json.translated_action t("fact_#{action.to_sym}_action".to_sym)

json.subject subject.to_s

json.time_ago time_ago_in_words(Time.at(created_at.to_time))

json.id activity.id

json.activity do |json|

  case action
  when "added_supporting_evidence", "added_weakening_evidence"
    json.action       :added
    json.evidence     subject.to_s
    json.evidence_url friendly_fact_path(subject)

    if showing_notifications
      json.fact truncate("#{object}", length: 85, separator: " ")
    else
      json.fact         Facts::Fact.for(fact: object, view: self).to_hash
    end
    json.fact_url     friendly_fact_path(object)
    json.fact_displaystring truncate(object.data.displaystring.to_s, length: 48)

    if action == "added_supporting_evidence"
      json.type :supporting
    else
      json.type :weakening
    end

  when "added_subchannel"
    subject_creator_graph_user = subject.created_by
    subject_creator_user = subject_creator_graph_user.user

    if subject.created_by.user == current_user
      json.channel_owner "your"
    else
      json.channel_owner "#{subject.created_by.user.username}'s"
    end

    json.channel_owner_profile_url channel_path(subject_creator_user, subject_creator_graph_user.stream_id)
    json.channel_title             subject.title
    json.channel_url               channel_path(subject_creator_user, subject.id)


    json.to_channel_title          object.title
    json.to_channel_url            channel_path(object.created_by.user, object.id)
  when "created_channel"
    json.channel_title             subject.title
    json.channel_url               channel_path(subject.created_by.user, subject.id)

    json.created_channel_definition t(:created_channel)
  when "added_fact_to_channel"
    json.partial! 'activities/added_fact_to_channel_activity',
        subject: subject,
        object: object,
        user: user
  when "added_first_factlink"
    json.fact         Facts::Fact.for(fact: subject, view: self).to_hash
  when "believes", "doubts", "disbelieves"
    if showing_notifications
      json.action action

      json.translated_action case action.to_sym
        when :believes
          t(:fact_believe_past_action)
        when :disbelieves
          t(:fact_disbelieve_past_action)
        when :doubts
          t(:fact_doubt_past_action)
        else
          ""
        end


      if subject.class.to_s == "Fact"
        json.fact_path friendly_fact_path subject
        json.subject truncate("#{subject}", length: 85, separator: ' ')
      elsif subject.class.to_s == "FactRelation"
        json.fact_path friendly_fact_path subject.from_fact
        json.subject truncate("#{subject.from_fact}", length: 85, separator: ' ')
      end
    else
      json.fact Facts::Fact.for(fact: subject, view: self).to_hash
    end


  when "created_conversation"
    json.target_url conversation_path(subject)

    json.conversation do |conversation|
      conversation.url conversation_path(subject)
    end
    json.message do |message|
      message.content truncate("#{subject.messages.first.content}", length: 85, separator: ' ')
    end
  end
end
