redis_conf = YAML::load_file(Rails.root.join('config/redis.yml'))[Rails.env]['redis']

connection_hash = {
  :host => redis_conf['host'],
  :port => redis_conf['port'],
  :db => redis_conf['database']
}

Ohm.connect(connection_hash)
Redis.current = Redis.new(connection_hash)
Redis::Aid.redis = Redis.new(connection_hash)

