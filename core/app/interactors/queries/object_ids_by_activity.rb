require_relative '../pavlov'

module Queries
  class ObjectIdsByActivity
    include Pavlov::Query

    arguments :activity, :class_name, :list

    def execute
      listener.add_to(@activity)
    end

    def listener
      Activity::Listener.all[{class: @class_name, list: @list}]
    end

    def authorized?
      true
    end
  end
end
