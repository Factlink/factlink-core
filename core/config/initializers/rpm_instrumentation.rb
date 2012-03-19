# require 'new_relic/agent/method_tracer'
# Mustache::Railstache.class_eval do
#   include NewRelic::Agent::MethodTracer
#   add_method_tracer :to_json
# end
# 
# #require mustache partial views (the autoloader does not find them)
# Dir["#{Rails.root}/app/views/**/_*.rb"].each do |path|
#   require_dependency path
# end
# 
# 
# Facts::Fact.class_eval do
#   include NewRelic::Agent::MethodTracer
#   add_method_tracer :interacting_users
# end