redis_conf = YAML::load_file(Rails.root.join('config/redis.yml'))[Rails.env]['redis']

# Setting db doesn't always work, check with ohm and redis client, if you add it again.
connection_hash = {
  :host => redis_conf['host'],
  :port => redis_conf['port']
}

Ohm.connect(connection_hash)
Redis.current = Redis.new(connection_hash)
Redis::Aid.redis = Redis.new(connection_hash)

