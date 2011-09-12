redis_conf = YAML::load_file(Rails.root.join('config/redis.yml'))[Rails.env]['redis']

Ohm.connect(
  :host => redis_conf['host'],
  :port => redis_conf['port'],
  :db => redis_conf['database']
)