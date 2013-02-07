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
    mongoid_conf = YAML::load_file(Rails.root.join('config/mongoid.yml'))[Rails.env]['sessions']['default']

    session = Moped::Session.new([mongoid_conf['hosts'][0]])
    session.use mongoid_conf['database'].to_sym

    session.collections.each do |collection|
      unless collection.name == "users" and collection.name != "system.indexes"
        collection.drop()
      end
    end

    if opts[:users] == :truncate
      # HACK; sorry, don't know efficient way, and shouldn't matter to much for development
      session.collections.each do |collection|
        if collection.name == "users"
          collection.drop()
        end
      end
    else
      User.all.each do |u|
        u.send(:create_graph_user) {}
      end
    end

  else
    puts "I only truncate in development!!"
  end
end
