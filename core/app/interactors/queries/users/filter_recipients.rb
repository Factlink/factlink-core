module Queries
  module Users
    class FilterRecipients
      include Pavlov::Query

      private

      attribute :graph_user_ids, Array
      attribute :type, String

      def execute
        query :users_by_ids, user_ids: recipients_ids
      end

      def recipients_ids
        recipients.map do |user|
          user.id.to_s
        end
      end

      def recipients
        UserNotification.users_receiving(type).any_in(graph_user_id: graph_user_ids)
      end
    end
  end
end
