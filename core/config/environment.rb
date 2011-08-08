# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
FactlinkUI::Application.initialize!

#goddamn fucking nasty, this:
#hardcore require those files because they can't figure it out on their own
%W(opinionable).each do |file|
  require File.expand_path("../../app/classes/#{file}",__FILE__)
end

['basefact','opinion','fact_graph', 'fact','fact_relation','graph_user','our_ohm','site'].each do |file|
  require File.expand_path("../../app/ohm-models/#{file}",__FILE__)
end
