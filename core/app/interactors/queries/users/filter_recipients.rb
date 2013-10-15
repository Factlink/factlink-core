module Interactors
  module Queries
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
        users.select do |user|
          user.user_notification.can_receive?(type)
        end
      end

      def users
        graph_user_ids.map do |graph_user_id|
          GraphUser[graph_user_id].user
        end
      end
    end
  end
end
