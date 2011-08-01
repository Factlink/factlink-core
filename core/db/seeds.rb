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


  users = FactoryGirl.create_list(:user,5)


  user = User.new(:username => "merijn",
                :email => "merijn@gmail.com",
                :confirmed_at => DateTime.now,
                :password => "merijn481",
                :password_confirmation => "merijn481")
  user.save

  user1 = User.new(:username => "tomdev",
                :email => "tom@codigy.nl",
                :confirmed_at => DateTime.now,
                :password => "123hoi",
                :password_confirmation => "123hoi")
  user1.save

  jordin = User.new(:username => "jordin",
                :email => "jordin@factlink.com",
                :confirmed_at => DateTime.now,
                :password => "Jordin87",
                :password_confirmation => "Jordin87")
  jordin.save
    
  remon = User.new(:username => "remon",
                 :email => "remon@factlink.com",
                 :confirmed_at => DateTime.now,
                 :password => "remon123",
                 :password_confirmation => "remon123")
  remon.save  
    
    
  salvador = User.new(:username => "salvador",
                :email => "salvador@factlink.com",
                :confirmed_at => DateTime.now,
                :password => "salvador123",
                :password_confirmation => "salvador123")
  salvador.save
  
  mark = User.new(:username => "mark",
                :email => "mark@factlink.com",
                :confirmed_at => DateTime.now,
                :password => "mark123",
                :password_confirmation => "mark123")
  mark.save
  
  joel = User.new(:username => "joel",
                :email => "joel@factlink.com",
                :confirmed_at => DateTime.now,
                :password => "joel123",
                :password_confirmation => "joel123")
  joel.save
  
 
 
 

  # fact = Fact.first
  # Fact.excludes(:_id => fact.id).each do |evidence|
  #   fact.add_evidence(:supporting, evidence, user)
  # end



# Commit the indices to Solr
Sunspot.commit