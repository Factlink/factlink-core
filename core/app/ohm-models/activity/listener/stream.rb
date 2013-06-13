class Activity < OurOhm
  class Listener
    class Stream < Activity::Listener
      # This class describes which activities will be pushed to the streams
      # of people who follow the creator of the activity
      include Followers
      def initialize
        stream_activities_because_you_follow_someone = [
          added_a_fact_to_a_channel,
          followed_someone_else
        ]
        super do
          activity_for "GraphUser"
          named :stream_activities
          stream_activities_because_you_follow_someone.each { |a| activity a }
        end
      end

      def added_a_fact_to_a_channel
        # If you follow someone, you receive all reposts they do
        {
          subject_class: 'Fact',
          action: :added_fact_to_channel,
          write_ids: ->(a) { followers_for_graph_user(a.user_id)}
        }
      end

      def followed_someone_else
        # If you follow someone, you get activities when they follow someone,
        # except when they follow you
        {
          subject_class: 'GraphUser',
          action: 'followed_user',
          write_ids: ->(a) { followers_for_graph_user(a.user_id) - [a.subject_id]}
        }
      end
    end
  end
end
