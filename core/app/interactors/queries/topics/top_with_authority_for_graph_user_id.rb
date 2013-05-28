module Queries
  module Topics
    class TopWithAuthorityForGraphUserId
      include Pavlov::Query

      arguments :graph_user_id, :limit_topics

      def execute


      end
    end
  end
end
