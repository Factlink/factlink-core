if defined?(NewRelic)
  require 'new_relic/agent/method_tracer'

  GC::Profiler.enable

  Ability.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :initialize
    add_method_tracer :can?
    add_method_tracer :cannot?
  end

  Pavlov::Operation.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :initialize, 'Pavlov/#{self.class.name}/initialize'
    add_method_tracer :call, 'Pavlov/#{self.class.name}/call'
  end

  Roadie::Inliner.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :execute
  end

  Mail.class_eval do
    class << self
      include ::NewRelic::Agent::MethodTracer
      add_method_tracer :deliver
    end
  end

  ApplicationController.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :check_preferred_browser
    add_method_tracer :track_click
    add_method_tracer :initialize_mixpanel
    add_method_tracer :set_last_interaction_for_user
  end

  SitesController.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :is_blacklisted
  end

  Moped::Connection.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :connect, 'Moped/connect/#{self.host}:#{self.port} (timeout: #{self.timeout}, ssl: #{!!self.options[:ssl]})'
  end

end
