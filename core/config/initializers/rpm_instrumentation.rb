if defined?(NewRelic)
  require 'new_relic/agent/method_tracer'

  Ability.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :initialize
    add_method_tracer :can?
    add_method_tracer :cannot?
  end

  FactGraph.class_eval do
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
    add_transaction_tracer :recalculate, category: :task, name: 'recalculate'
  end

  Pavlov::Operation.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :initialize, 'Pavlov/#{self.class.name}/initialize'
    add_method_tracer :call, 'Pavlov/#{self.class.name}/call'
  end

  Queries::ContainingChannelIdsForChannelAndUser.class_eval do
    add_method_tracer :graph_user_channels
    add_method_tracer :containing_channels
    add_method_tracer :union_ids
  end

  Roadie::Inliner.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :execute
  end

  AddFactToChannelJob.class_eval do
    include NewRelic::Agent::MethodTracer
    add_method_tracer :initialize
    add_method_tracer :add_to_channel
    add_method_tracer :add_to_unread
    add_method_tracer :propagate_to_channels
    add_method_tracer :can_perform
    add_method_tracer :should_perform
  end

end
