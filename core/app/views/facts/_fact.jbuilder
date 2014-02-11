dead_fact = query(:'facts/get_dead', id: fact.id.to_s)
dead_fact.to_hash.each do |key, val|
  json.set! key, val
end
