def self.truncate(opts)
  if Rails.env.development?
    # truncate redis
    Redis.current.flushall

    # truncate redis resque
    resque_redis_conf = YAML::load_file(Rails.root.join('config/resque.yml'))[Rails.env]
    Redis.new(url: "redis://#{resque_redis_conf}/0").flushall

    # truncate elasticsearch
    ElasticSearch.truncate

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

    # from http://stackoverflow.com/a/6150228/623827
    config = ActiveRecord::Base.configurations[::Rails.env]
    ActiveRecord::Base.establish_connection
    case config["adapter"]
    when "mysql", "postgresql"
      ActiveRecord::Base.connection.tables.each do |table|
        next if table == 'schema_migrations'
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end
    when "sqlite", "sqlite3"
      ActiveRecord::Base.connection.tables.each do |table|
        next if table == 'schema_migrations'

        ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
        ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
      end
      ActiveRecord::Base.connection.execute("VACUUM")
    end

  else
    puts "I only truncate in development!!"
  end
end
