require 'pavlov'
require_relative '../kill_object'
require_relative 'users_by_ids'

module Queries
  class UsersByGraphUserIds
    include Pavlov::Query

    arguments :graph_user_ids

    def validate
      @graph_user_ids.each { |id| raise "id should be a positive integer." unless id.to_i > 0 }
    end

    def execute
      ids = @graph_user_ids.map do |graph_user_id|
        GraphUser[graph_user_id].user_id
      end

      query :users_by_ids, ids
    end

    def authorized?
      @options[:current_user]
    end
  end
end
