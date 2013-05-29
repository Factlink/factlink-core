require 'pavlov'

module Queries
  class ObjectIdsByActivity
    include Pavlov::Query

    arguments :activity, :class_name, :list

    def execute
      ids = []
      listeners.each do |listener|
        ids += listener.add_to(@activity)
      end
      ids
    end

    def listeners
      Activity::Listener.all[{class: @class_name, list: @list}]
    end
  end
end
