json.displaystring fact.data.displaystring
json.id fact.id
json.site_id fact.site_id

if current_graph_user
  channel_list = ChannelList.new(current_graph_user)
  containing_channel_ids = channel_list.containing_real_channel_ids_for_fact fact
  json.containing_channel_ids containing_channel_ids
end
json.url friendly_fact_path(fact)

if channel
  deletable_from_channel = user_signed_in? and
                           channel.is_real_channel? and
                           channel.created_by == current_graph_user
  json.deletable_from_channel? deletable_from_channel
  # TODO : this should be moved to view logic in the frontend,
  #        however, because of the strong coupling with channel
  #        this isn't trivial, so I decided to postpone this for
  #        now, as this might also change in the future (maybe
  #        'repost' will always suffice for instance)
  post_action = fact.created_by == channel.created_by ? 'Posted' : 'Reposted'
  json.post_action post_action

  timestamp_in_seconds = timestamp / 1000
  friendly_time = TimeFormatter.as_time_ago(timestamp_in_seconds)
  json.friendly_time friendly_time
end

json.created_by do |j|
  j.partial! partial: "users/user_authority_for_subject_partial",
                formats: [:json],
                handlers: [:jbuilder],
                locals: {
                  user: fact.created_by.user,
                  subject: fact
                }
end

json.created_by_ago "Created #{TimeFormatter.as_time_ago fact.data.created_at} ago"

json.fact_title fact.data.title
json.fact_wheel do |j|
  j.partial! partial: 'facts/fact_wheel',
                formats: [:json], handlers: [:jbuilder],
                locals: { fact: fact }
end
json.fact_url(fact.has_site? ? fact.site.url : nil)

begin
  proxy_scroll_url = FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(fact.site.url) + "&scrollto=" + URI.escape(fact.id)
  json.proxy_scroll_url proxy_scroll_url
rescue
  nil
end

json.timestamp timestamp
