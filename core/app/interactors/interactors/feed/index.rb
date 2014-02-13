module Interactors
  module Feed
    class Index
      include Pavlov::Query

      arguments :timestamp

      def execute
        return [] unless current_user

        retrieved_activities.map do |activity_hash|
          begin
            activity = activity_hash[:item]

            h = {
              timestamp: activity_hash[:score],
              user: query(:dead_users_by_ids, user_ids: activity.user.user_id).first,
              action: activity.action,
              time_ago: TimeFormatter.as_time_ago(activity.created_at.to_time),
              id: activity.id
            }
            case activity.action
            when "created_comment", "created_sub_comment"
              h[:fact] = query(:'facts/get_dead', id: activity.object.id.to_s)
            when "followed_user"
              subject_user = query(:dead_users_by_ids, user_ids: activity.subject.user_id).first
              h[:followed_user] = subject_user
            end

            h
          rescue
            nil
          end
        end.compact
      end

      def retrieved_activities
        activities.below(timestamp || 'inf',
                         count: 20,
                         reversed: true,
                         withscores: true).compact
      end

      def activities
        current_user.graph_user.stream_activities
      end

      def current_user
        pavlov_options[:current_user]
      end
    end
  end
end
