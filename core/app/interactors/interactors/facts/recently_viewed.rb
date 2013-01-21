require 'pavlov'

module Interactors
  module Facts
    class RecentlyViewed
      include Pavlov::Interactor

      def execute
        recently_viewed_facts.top_facts(5)
      end

      def authorized?
        @options[:current_user]
      end

      private
      def recently_viewed_facts
        RecentlyViewedFacts.by_user_id(@options[:current_user].id)
      end
    end
  end
end
