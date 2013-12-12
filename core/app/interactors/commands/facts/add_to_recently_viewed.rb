module Commands
  module Facts
    class AddToRecentlyViewed
      include Pavlov::Command

      arguments :fact_id, :user_id

      def execute
        RecentlyViewedFacts.by_user_id(user_id).add_fact_id fact_id
      end
    end
  end
end
