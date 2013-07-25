module Commands
  module Stream
    class AddActivities
      include Pavlov::Command
      arguments :activities
      attribute :pavlov_options, Hash, default: {}

      def execute
        activities.each do |activity|
          activity.add_to_list_with_score stream
        end
      end

      def stream
        @stream ||= current_graph_user.stream_activities
      end

      def current_graph_user
        pavlov_options[:current_user].graph_user
      end
    end
  end
end
