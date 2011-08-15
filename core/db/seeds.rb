require File.expand_path('../../spec/factories', __FILE__)


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Clear stuff
if Rails.env.development? or Rails.env.test?
  $redis.FLUSHDB                # Clear the Redis DB

  ['development'].each do |env|
    mongoid_conf = YAML::load_file(Rails.root.join('config/mongoid.yml'))[env]

    puts mongoid_conf['database']
  
    mongo_db = Mongo::Connection.new(mongoid_conf['host'], 
                                     mongoid_conf['port']).db(mongoid_conf['database'])
    mongo_db.collections.each { |col| col.drop() unless col.name == 'system.indexes'}
  end

  Sunspot.remove_all!(FactData) # Remove the indices of all Facts in Solr.
end


# Commit the indices to Solr
Sunspot.commit