def self.truncate(opts)
  if Rails.env.development?
    # truncate redis
    Ohm.flush

    # truncate redis resque
    resque_redis_conf = YAML::load_file(Rails.root.join('config/resque.yml'))[Rails.env]
    Ohm.connect(:url => "redis://#{resque_redis_conf}/0")
    Ohm.flush

    # truncate elasticsearch
    ElasticSearch.clean

    #truncate mongoid
    mongoid_conf = YAML::load_file(Rails.root.join('config/mongoid.yml'))[Rails.env]

    mongo_db = Mongo::Connection.new(mongoid_conf['host'],
    mongoid_conf['port']).db(mongoid_conf['database'])
    mongo_db.collections.each { |col| col.drop() unless col.name == 'system.indexes' || col.name == "users"}

    if opts[:users] == :truncate
      # HACK; sorry, don't know efficient way, and shouldn't matter to much for development
      mongo_db.collections.each { |col| col.drop() if col.name == "users"}
    else
      User.all.each do |u|
        u.send(:create_graph_user) {}
      end
    end

  else
    puts "I only truncate in development!!"
  end
end
