dead_fact = query(:'facts/get_dead', id: fact.id.to_s)
dead_fact_creator = query(:'users_by_ids', user_ids: [fact.created_by_id], by: :graph_user_id).first
dead_fact_creator_graph_user = Struct.new(:id).new(fact.created_by_id)
containing_channel_ids = query(:'facts/containing_channel_ids_for_user', fact: fact)

json.displaystring dead_fact.displaystring
json.id dead_fact.id

if current_graph_user
  json.containing_channel_ids containing_channel_ids
end

json.url friendly_fact_path(dead_fact)

json.sharing_url ::FactUrl.new(dead_fact).sharing_url

json.created_by do |j|
  json.partial! 'users/user_partial', user: dead_fact_creator
end

json.created_at dead_fact.created_at

json.fact_title dead_fact.title
json.tally do |j|
  j.partial! 'believable/votes', votes: dead_fact.votes
end

if dead_fact.site_url
  json.fact_url dead_fact.site_url
  json.proxy_scroll_url dead_fact.url.proxy_scroll_url
end

json.is_deletable dead_fact.deletable?
