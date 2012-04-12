cached_generic_icon  = image_tag('activities/icon-generic.png')
cached_channel_icon  = image_tag('activities/icon-channel.png')
cached_evidence_icon = image_tag('activities/icon-evidencetofactlink.png')

cached_channel_definition  = t(:channel)
cached_channels_definition = t(:channels)


json.array!(@activities) do |json, activity|
  graph_user = activity.user
  user = graph_user.user

  subject = activity.subject
  object = activity.object
  action = activity.action


  json.username user.username
  json.user_profile_url channel_path(user,graph_user.stream_id)
  size = 32
  json.avatar image_tag(user.avatar_url(size: size), :width => size)
  
  json.action action
  
  json.time_ago "#{time_ago_in_words(activity.created_at)} ago"

  json.activity do |json|
    
    
    case action
    when "added_supporting_evidence", "added_weakening_evidence"
      json.action       :added
      json.evidence     subject.to_s
      json.evidence_url friendly_fact_path(subject)
      json.fact         object.to_s
      json.fact_url     friendly_fact_path(object)

      if action == "added_supporting_evidence"
        json.type :supporting
      else
        json.type :weakening
      end

      json.icon cached_evidence_icon
    when "added_subchannel"
      subject_creator_graph_user = subject.created_by
      subject_creator_user = subject_creator_graph_user.user
      
      json.channel_owner             subject_creator_user.username
      json.channel_owner_profile_url channel_path(subject_creator_user, subject_creator_graph_user.stream_id)
      json.channel_title             subject.title
      json.channel_url               channel_path(subject_creator_user, subject)
      
      object_creator_user = object.created_by.user

      json.to_channel_title          object.title
      json.to_channel_url            channel_path(object_creator_user, object)

      json.icon                      cached_channel_icon
      json.channel_definition        cached_channel_definition
      json.channels_definition       cached_channels_definition
    end
  end
end