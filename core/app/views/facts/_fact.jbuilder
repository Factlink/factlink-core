# set optional arguments to nil so we can easily check with if
channel  ||= nil
timestamp ||= 0
# TODO: set timestamp to nil, but this always defaulted to 0
# so check that nothing depends on it.

dead_fact = query(:'facts/get_dead', id: fact.id.to_s)
dead_fact_creator = query(:'users_by_graph_user_ids', graph_user_ids: [fact.created_by_id]).first
dead_fact_creator_graph_user = Struct.new(:id).new(fact.created_by_id)
containing_channel_ids = query(:'facts/containing_channel_ids_for_user', fact: fact)


json.displaystring dead_fact.displaystring
json.id dead_fact.id

if current_graph_user
  json.containing_channel_ids containing_channel_ids
end


json.url friendly_fact_path(dead_fact)

if channel
  deletable = (user_signed_in? && channel.created_by == current_graph_user)
  json.deletable_from_channel? deletable
end


json.created_by do |j|
  json.partial! 'users/user_partial', user: dead_fact_creator
  json.authority_for_subject do |json|
    authority = Authority.on(dead_fact, for: dead_fact_creator_graph_user).to_f + 1.0
    json.authority NumberFormatter.new(authority).as_authority
    json.id dead_fact.id
  end
end

json.created_by_ago "Posted #{TimeFormatter.as_time_ago dead_fact.created_at} ago"

json.fact_title dead_fact.title
json.fact_wheel do |j|
  j.partial! partial: 'facts/fact_wheel',
                formats: [:json], handlers: [:jbuilder],
                locals: { dead_fact_wheel: dead_fact.wheel }
end

if dead_fact.site_url
  json.fact_url dead_fact.site_url
  json.proxy_scroll_url dead_fact.url.proxy_scroll_url
end

json.timestamp timestamp

json.evidence_count dead_fact.evidence_count
