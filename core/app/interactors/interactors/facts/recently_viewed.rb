require 'pavlov'

module Interactors
  module Facts
    class RecentlyViewed
      include Pavlov::Interactor
      include Util::CanCan

      def execute
        return [] unless @options[:current_user]

        recently_viewed_facts.top(5)
      end

      def authorized?
        can? :index, Fact
      end

      private

      def recently_viewed_facts
        RecentlyViewedFacts.by_user_id(@options[:current_user].id)
      end
    end
  end
end
