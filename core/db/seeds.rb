# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


# Clear stuff
Site.all.delete
FactlinkTop.all.delete
FactlinkSub.all.delete

# Site
site = Site.new(:url => "http://en.wikipedia.org/wiki/Batman")
site.save

# FactlinkTops
ft1 = FactlinkTop.new(:displaystring => "Batman is a fictional character created by the artist Bob Kane and writer Bill Finger",
                      :site => site
                      )
ft2 = FactlinkTop.new(:displaystring => "Batman's secret identity is Bruce Wayne",
                      :site => site
                      )
ft3 = FactlinkTop.new(:displaystring => "he swore revenge on crime",
                      :site => site
                      )
ft4 = FactlinkTop.new(:displaystring => "Batman became a very popular character soon after his introduction",
                      :site => site
                      )
ft5 = FactlinkTop.new(:displaystring => "A cultural icon, Batman has been licensed and adapted into a variety of media",
                      :site => site
                      )
ft6 = FactlinkTop.new(:displaystring => "and appears on a variety of merchandise sold all over the world such as toys and video games",
                      :site => site
                      )

# FactlinkSubs


