module Interactors
  module Facts
    class CreatedByUser
      include Pavlov::Interactor
      include Util::CanCan

      arguments :username, :count, :from

      def execute
        query :'facts/get_paginated',
              key: created_facts_key, from: from, count: count
      end

      def created_facts_key
        user.graph_user.sorted_created_facts.key.to_s
      end

      def user
        query :user_by_username, username: username
      end

      def authorized?
        can? :index, Fact
      end
    end
  end
end
