if ENV['NEWRELIC'] || Rails.env == 'production'
  require 'newrelic_rpm'
  require 'rpm_contrib'
  require 'new_relic/agent/method_tracer'

  Ability.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :initialize
    add_method_tracer :can?
    add_method_tracer :cannot?
  end

end
