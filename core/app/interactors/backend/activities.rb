module Backend
  module Activities
    extend self

    def activities_older_than(activities_set:, timestamp: nil, count: 20)
      retrieved_activities = activities_set.below(timestamp || 'inf',
                               count: count,
                               reversed: true,
                               withscores: true).compact

      retrieved_activities.map do |activity_hash|
        activity = activity_hash[:item]

        h = {
          timestamp: activity_hash[:score],
          action: activity.action,
          created_at: activity.created_at.to_time,
          time_ago: TimeFormatter.as_time_ago(activity.created_at.to_time),
          id: activity.id
        }
        case activity.action
        when "created_comment"
          h[:fact] = Pavlov.query(:'facts/get_dead', id: activity.object_id.to_s)
          h[:comment] = Pavlov.query(:'comments/by_ids', ids: [activity.subject_id.to_s]).first
          h[:user] = h[:comment].created_by
        when "created_sub_comment"
          h[:fact] = Pavlov.query(:'facts/get_dead', id: activity.object_id.to_s)
          h[:comment] = Pavlov.query(:'comments/by_ids', ids: [activity.subject.parent_id.to_s]).first
          h[:sub_comment] = Backend::SubComments::dead_for(activity.subject)
          h[:user] = h[:sub_comment].created_by
        when "followed_user"
          subject_user = Pavlov.query(:dead_users_by_ids, by: :graph_user_id, user_ids: activity.subject_id).first
          h[:followed_user] = subject_user
          h[:user] = Pavlov.query(:dead_users_by_ids, by: :graph_user_id, user_ids: activity.user_id).first
        end

        h
      end
    end
  end
end
