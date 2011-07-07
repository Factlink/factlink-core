require File.expand_path('../../spec/factories', __FILE__)


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Clear stuff
if Rails.env.development? or Rails.env.test?
  $redis.FLUSHDB                # Clear the Redis DB

  ['test','development'].each do |env|
    mongoid_conf = YAML::load_file(Rails.root.join('config/mongoid.yml'))[env]

    puts mongoid_conf['database']
  
    mongo_db = Mongo::Connection.new(mongoid_conf['host'], 
                                     mongoid_conf['port']).db(mongoid_conf['database'])
    mongo_db.collections.each { |col| col.drop() unless col.name == 'system.indexes'}
  end

  Sunspot.remove_all!(Fact) # Remove the indices of all Facts in Solr.
end

users = FactoryGirl.create_list(:user,5)

# Site
site = Site.new(:url => "http://en.wikipedia.org/wiki/Batman")
site.save

facts = [
'Batman is a fictional character created by the artist Bob Kane and writer Bill Finger',
'Batman\'s secret identity is Bruce Wayne',
'Batman operates in the fictional American Gotham City',
'He fights an assortment of villains such as the Joker, the Penguin, Two-Face, Poison Ivy and Catwoman',
'The late 1960s Batman television series used a camp aesthetic which continued to be associated with the character for years after the show ended']

facts.each do |fact|
  Fact.create!( :displaystring => fact,
                    :site => site,
                    :created_by => users[0]
  )
end

fr = FactRelation.get_or_create(Fact.first,:supports, Fact.last, users[0])
fr.save()

# Commit the indices to Solr
Sunspot.commit