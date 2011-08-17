mongoid_conf = YAML::load_file(Rails.root.join('config/mongoid.yml'))[Rails.env]

Mongoid.configure do |config|
 config.master = Mongo::Connection.new(mongoid_conf['host'], 
                                       mongoid_conf['port']).db(mongoid_conf['database'])
end