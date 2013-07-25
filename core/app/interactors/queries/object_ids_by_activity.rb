require 'pavlov'

module Queries
  class ObjectIdsByActivity
    include Pavlov::Query

    arguments :activity, :class_name, :list
    attribute :pavlov_options, Hash, default: {}

    def execute
      listeners.map do |listener|
        listener.add_to(@activity)
      end.flatten
    end

    def listeners
      Activity::Listener.all[{class: @class_name, list: @list}]
    end
  end
end
