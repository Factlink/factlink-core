redis_conf = YAML::load_file(Rails.root.join('config/redis.yml'))[Rails.env]

# Connect to Redis
$redis = Redis.new(
  :host => redis_conf['host'],
  :port => redis_conf['port'],
  :db => redis_conf['database']
)

Ohm.connect(
  :host => redis_conf['host'],
  :port => redis_conf['port'],
  :db => redis_conf['database']
)