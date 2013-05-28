module Queries
  module Topics
    class TopWithAuthorityForGraphUserId
      include Pavlov::Query

      attributes :graph_user_id, :limit_topics

      def execute


      end
    end
  end
end
