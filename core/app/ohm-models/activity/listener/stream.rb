class Activity < OurOhm
  class Listener
    class Stream < Activity::Listener
      include Followers
      def initialize
        stream_activities_because_you_follow_someone = [
          forGraphUser_someone_you_follow_added_a_fact_to_a_channel,
          forGraphUser_someone_you_follow_followed_someone_else,
        ]
        super do
          activity_for "GraphUser"
          named :stream_activities
          stream_activities_because_you_follow_someone.each { |a| activity a }
        end
      end

      def forGraphUser_someone_you_follow_added_a_fact_to_a_channel
        {
          subject_class: 'Fact',
          action: :added_fact_to_channel,
          write_ids: lambda {|a| followers_for_graph_user(a.user_id)}
        }
      end

      def forGraphUser_someone_you_follow_followed_someone_else
        {
          subject_class: 'GraphUser',
          action: 'followed_user',
          write_ids: lambda {|a| followers_for_graph_user(a.user_id) - [a.subject_id]}
        }
      end
    end
  end
end
