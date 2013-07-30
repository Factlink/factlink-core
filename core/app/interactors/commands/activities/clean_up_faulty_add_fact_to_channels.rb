require 'pavlov'

module Commands
  module Activities
    class CleanUpFaultyAddFactToChannels
      include Pavlov::Command

      private

      def execute
        activities_ids.each do |id|
          activity = Activity[id]
          remove_activity_if_faulty activity
        end
      end

      def remove_activity_if_faulty activity
        activity.delete if should_remove(activity)
      end

      def activities_ids
        Activity.find(action: 'added_fact_to_channel').ids
      end

      def should_remove activity
        activity.object.type != 'channel'
      end
    end
  end
end
