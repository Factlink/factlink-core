def self.truncate
  if Rails.env.development?
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
