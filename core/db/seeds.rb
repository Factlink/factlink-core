# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Clear stuff
if Rails.env.development? or Rails.env.test?
  $redis.FLUSHDB                # Clear the Redis DB
  User.all.delete
  Site.all.delete               # Self explainatory
  Factlink.all.delete           # Self explainatory
  Sunspot.remove_all!(Factlink) # Remove the indices of all Factlinks in Solr.
end

# A user
user = User.new(:username => "robin",
                :email => "robin@gothamcity.com",
                :confirmed_at => DateTime.now,
                :password => "hshshs",
                :password_confirmation => "hshshs")
user.save

user1 = User.new(:username => "tomdev",
                :email => "tom@codigy.nl",
                :confirmed_at => DateTime.now,
                :password => "123hoi",
                :password_confirmation => "123hoi")
user1.save


# Opinionators
user2 = User.new(:username => "michael_night",
                :email => "a@a.com",
                :confirmed_at => DateTime.now,
                :password => "123hoi",
                :password_confirmation => "123hoi")
user2.save

user3 = User.new(:username => "kate_upton",
                :email => "b@b.com",
                :confirmed_at => DateTime.now,
                :password => "123hoi",
                :password_confirmation => "123hoi")
user3.save

user3 = User.new(:username => "george_lucas",
                :email => "c@c.com",
                :confirmed_at => DateTime.now,
                :password => "123hoi",
                :password_confirmation => "123hoi")
user3.save

user4 = User.new(:username => "will_smith",
                :email => "d@d.com",
                :confirmed_at => DateTime.now,
                :password => "123hoi",
                :password_confirmation => "123hoi")
user4.save

user5 = User.new(:username => "snookie",
                :email => "e@e.com",
                :confirmed_at => DateTime.now,
                :password => "123hoi",
                :password_confirmation => "123hoi")
user5.save


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
  Factlink.create!( :displaystring => fact,
                    :site => site,
                    :created_by => user
  )
end

parent  = Factlink.all[0]
child   = Factlink.all[1]

child.set_parent parent.id
parent.add_child_as_supporting(child, user)

child.add_believer(user, parent)
child.add_believer(user1, parent)
child.add_believer(user2, parent)

child.add_doubter(user3, parent)

child.add_disbeliever(user4, parent)
child.add_disbeliever(user5, parent)

# 500.times do |x|
#   Factlink.create!( :displaystring => facts[x % facts.count],
#                     :site => site,
#                     :created_by => user
#   )  
# end

# Commit the indices to Solr
Sunspot.commit