class Activity < OurOhm
  class Listener
    class Stream < Activity::Listener

      # This class describes which activities will be pushed to the streams
      # of people who follow the creator of the activity

      # NOTE: Please update the tags in _activity.json.jbuilder when changing this!!

      include Followers
      def initialize
        stream_activities_because_you_follow_someone = [
          followed_someone_else
        ]
        super do
          activity_for "GraphUser"
          named :stream_activities
          stream_activities_because_you_follow_someone.each { |a| activity a }
        end
      end

      def followed_someone_else
        # If you follow someone, you get activities when they follow someone,
        # except when they follow you
        {
          subject_class: 'GraphUser',
          action: 'followed_user',
          write_ids: ->(a) { followers_for_graph_user(a.user_id) - [a.subject_id] }
        }
      end
    end
  end
end
