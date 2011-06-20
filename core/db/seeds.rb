# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


# Clear stuff

if Rails.env.development?
  Site.all.delete
  Factlink.all.delete

end

user = User.first

# Site
site = Site.new(:url => "http://en.wikipedia.org/wiki/Batman")
site.save


facts = ['Batman is a fictional character created by the artist Bob Kane and writer Bill Finger',
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

500.times do |x|
  Factlink.create!( :displaystring => facts[0],
                    :site => site,
                    :created_by => user
  )
end