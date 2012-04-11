cached_generic_icon  = image_tag('activities/icon-generic.png')
cached_channel_icon  = image_tag('activities/icon-channel.png')
cached_evidence_icon = image_tag('activities/icon-evidencetofactlink.png')

cached_channel_definition  = t(:channel)
cached_channels_definition = t(:channels)


json.array!(@activities) do |json, activity|
  graph_user = activity.user
  user = graph_user.user


  json.username user.username
  json.user_profile_url channel_path(user,graph_user.stream)
  size = 32
  json.avatar image_tag(user.avatar_url(size: size), :width => size)
  
  json.action activity.action
  
  json.time_ago "#{time_ago_in_words(activity.created_at)} ago"

  json.activity do |json|
    case activity.action
    when "added_supporting_evidence", "added_weakening_evidence"
      json.action       :added
      json.evidence     activity.subject.to_s
      json.evidence_url friendly_fact_path(activity.subject)
      json.fact         activity.object.to_s
      json.fact_url     friendly_fact_path(activity.object)

      the_action = activity.action
      if the_action == "added_supporting_evidence"
        json.type :supporting
      else
        json.type :weakening
      end

      json.icon cached_evidence_icon
    when "added_subchannel"
      json.channel_owner             activity.subject.created_by.user.username
      json.channel_owner_profile_url channel_path(activity.subject.created_by.user, activity.subject.created_by.stream)
      json.channel_title             activity.subject.title
      json.channel_url               channel_path(activity.subject.created_by.user, activity.subject)
      json.to_channel_title          activity.object.title
      json.to_channel_url            channel_path(activity.object.created_by.user, activity.object)

      json.icon                      cached_channel_icon
      json.channel_definition        cached_channel_definition
      json.channels_definition       cached_channels_definition
    end
  end
end