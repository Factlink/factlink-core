if defined?(NewRelic)
  require 'new_relic/agent/method_tracer'

  GC::Profiler.enable

  Ability.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :initialize
    add_method_tracer :can?
    add_method_tracer :cannot?
  end

  FactGraph.class_eval do
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
    include NewRelic::Agent::MethodTracer
    #add_transaction_tracer :recalculate, category: :task, name: 'recalculate'

    add_transaction_tracer :calculate_authority, category: :task, name: 'calculate_authority'
    add_transaction_tracer :calculate_user_opinions, category: :task, name: 'calculate_user_opinions'
    add_transaction_tracer :calculate_graph, category: :task, name: 'calculate_graph'
  end

  MapReduce.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :map_reduce, 'MapReduce/#{self.class.name}/map_reduce'
    add_method_tracer :process_all, 'MapReduce/#{self.class.name}/process_all'
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

  AddFactToChannelJob.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :initialize
    add_method_tracer :propagate_to_channels
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

  Moped::Connection.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :connect, 'Moped/connect/#{self.host}:#{self.port} (timeout: #{self.timeout}, ssl: #{!!self.options[:ssl]})'
  end

end
