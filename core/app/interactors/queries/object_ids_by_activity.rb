require_relative '../pavlov'

module Queries
  class ObjectIdsByActivity
    include Pavlov::Query

    arguments :activity, :class_name, :list

    def execute
      listener = Activity::Listener.all[{class: @class_name, list: @list}]
      listener.add_to(@activity)
    end

    def authorized?
      true
    end
  end
end
