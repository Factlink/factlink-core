module Interactors
  module Channels
    class ActivityCount
      include Pavlov::Interactor

      arguments :channel_id, :timestamp

      def execute
        old_query :"channels/activity_count", @channel_id, @timestamp
      end

      def authorized?
        pavlov_options[:no_current_user] == true or pavlov_options[:current_user]
      end
    end
  end
end
