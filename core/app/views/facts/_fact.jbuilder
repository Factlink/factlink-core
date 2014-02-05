dead_fact = query(:'facts/get_dead', id: fact.id.to_s)
dead_fact_creator = query(:'users_by_ids', user_ids: [fact.created_by_id], by: :graph_user_id).first
dead_fact_creator_graph_user = Struct.new(:id).new(fact.created_by_id)

json.displaystring dead_fact.displaystring
json.id dead_fact.id

json.url dead_fact.url.friendly_fact_path

json.created_by do |j|
  json.partial! 'users/user_partial', user: dead_fact_creator
end

json.created_at dead_fact.created_at

json.fact_title dead_fact.title

json.fact_url dead_fact.site_url
json.proxy_open_url dead_fact.url.proxy_open_url

json.is_deletable dead_fact.deletable?
