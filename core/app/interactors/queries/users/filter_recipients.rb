module Queries
  module Users
    class FilterRecipients
      include Pavlov::Query

      private

      attribute :graph_user_ids, Array
      attribute :type, String

      def execute
        recipients.map do |user|
          KillObject.user user
        end
      end

      def recipients
        UserNotification.users_receiving(type).any_in(graph_user_id: graph_user_ids)
      end
    end
  end
end
