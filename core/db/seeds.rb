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
  FactlinkTop.all.delete
  FactlinkSub.all.delete
end

# Site
site = Site.new(:url => "http://en.wikipedia.org/wiki/Batman")
site.save

# FactlinkTops
ft1 = FactlinkTop.new(:displaystring => "Batman is a fictional character created by the artist Bob Kane and writer Bill Finger",
                      :site => site
                      )
ft1.save

ft2 = FactlinkTop.new(:displaystring => "Batman's secret identity is Bruce Wayne",
                      :site => site
                      )
ft2.save

ft3 = FactlinkTop.new(:displaystring => "he swore revenge on crime",
                      :site => site
                      )
ft3.save

ft4 = FactlinkTop.new(:displaystring => "Batman became a very popular character soon after his introduction",
                      :site => site
                      )
ft4.save

ft5 = FactlinkTop.new(:displaystring => "A cultural icon, Batman has been licensed and adapted into a variety of media",
                      :site => site
                      )
ft5.save

ft6 = FactlinkTop.new(:displaystring => "and appears on a variety of merchandise sold all over the world such as toys and video games",
                      :site => site
                      )
ft6.save

# FactlinkSubs
fs1 = FactlinkSub.new(:title => "Original drawings by Bob Kane",
                      :content => "This is content for the baron, a fictional character. Created by Bob Kane. Here are some of the original drawings.",
                      :url => "http://google.com",
                      :factlink_top => ft1
                      )
fs1.save

fs2 = FactlinkSub.new(:title => "Bill Finger writes",
                      :content => "Bill Finger is a writer, with several books on his track record.",
                      :url => "http://bill-finger.com",
                      :factlink_top => ft1
                      )
fs2.save

fs3 = FactlinkSub.new(:title => "Another awesome fact",
                      :content => "Facts make the world go round. Nothing else.",
                      :url => "http://facts.com",
                      :factlink_top => ft1)
fs3.save

fs4 = FactlinkSub.new(:title => "This fact is true but might not be relevant",
                      :content => "The baron is inside. Something is either in the wisdom of heart and Louie is not happy with the default keyboards that we want to use. He only want Logitec. Stop.",
                      :url => "http://logitec.com",
                      :factlink_top => ft1)
fs4.save

fs5 = FactlinkSub.new(:title => "This fact will make you go crazy!",
                      :content => "Too bad he is not so awesome as the rest of us. If he was, he could use awesome mice and keyboards, like us, and like the way Steven wants it to be.",
                      :url => "http://crazywoman.com",
                      :factlink_top => ft1)
fs5.save

fs6 = FactlinkSub.new(:title => "My Baron is the nicest in the world.",
                      :content => "Baron me baron, at the moment we are working with compiled code :/",
                      :url => "http://baron.nl",
                      :factlink_top => ft1)
fs6.save

FactlinkTop.all.each do |f|
  f.created_by = User.first
  f.save
end

FactlinkSub.all.each do |f|
  f.created_by = User.first
  f.save
end