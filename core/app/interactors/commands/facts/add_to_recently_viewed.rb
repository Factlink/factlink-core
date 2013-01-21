require 'pavlov'

module Commands
  module Facts
    class AddToRecentlyViewed
      include Pavlov::Command

      arguments :fact_id, :user_id

      def execute
        RecentlyViewedFacts.by_user_id(@user_id).push_fact_id @fact_id
      end

      def validate
        validate_integer            :fact_id, @fact_id
        validate_hexadecimal_string :user_id, @user_id
      end

    end
  end
end
