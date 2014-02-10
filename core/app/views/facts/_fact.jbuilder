dead_fact = query(:'facts/get_dead', id: fact.id.to_s)

json.displaystring dead_fact.displaystring
json.id dead_fact.id

json.url dead_fact.url.friendly_fact_path


json.created_at dead_fact.created_at

json.fact_title dead_fact.title

json.fact_url dead_fact.site_url
json.proxy_open_url dead_fact.url.proxy_open_url

json.is_deletable dead_fact.deletable?
