module Interactors
  module Groups
    class Feed
      include Pavlov::Interactor
      include Util::CanCan

      arguments :group_id, :timestamp

      def authorized?
        can?(:access, Group.find(group_id))
      end

      def execute
        Backend::Activities.group(newest_timestamp: timestamp, group_id: group_id)
      end

      def validate
        validate_string :timestamp, timestamp unless timestamp.nil?
      end
    end
  end
end
