module Interactors
  module Channels
    class ActivityCount
      include Pavlov::Interactor

      arguments :channel_id, :timestamp

      def execute
        query :"channels/activity_count", @channel_id, @timestamp
      end

      def authorized?
        @options[:no_current_user] == true or @options[:current_user]
      end
    end
  end
end
