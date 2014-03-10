module Backend
  module Activities
    extend self

    def activities_older_than(activities_set:, timestamp: nil, count: 20)
      retrieved_activities = activities_set.below(timestamp || 'inf',
                               count: count,
                               reversed: true,
                               withscores: true).compact

      retrieved_activities.map { |activity_with_score| activity_hash activity_with_score }.compact
    end

    def activity_hash(item: , score:)
      activity = item

      base_activity_data = {
          timestamp: score,
          action: activity.action,
          created_at: activity.created_at.to_time,
          time_ago: TimeFormatter.as_time_ago(activity.created_at.to_time),
          id: activity.id
      }
      specialized_data =
        case activity.action
          when "created_comment"
            comment = Pavlov.query(:'comments/by_ids', ids: [activity.subject_id.to_s]).first
            {
                fact: Pavlov.query(:'facts/get_dead', id: activity.object_id.to_s),
                comment: comment,
                user: comment.created_by,
            }
          when "created_sub_comment"
            sub_comment = Backend::SubComments::dead_for(activity.subject)
            {
                fact: Pavlov.query(:'facts/get_dead', id: activity.object_id.to_s),
                comment: Pavlov.query(:'comments/by_ids', ids: [activity.subject.parent_id.to_s]).first,
                sub_comment: sub_comment,
                user: sub_comment.created_by,
            }
          when "followed_user"
            {
                followed_user: Pavlov.query(:dead_users_by_ids, by: :graph_user_id, user_ids: activity.subject_id).first,
                user: Pavlov.query(:dead_users_by_ids, by: :graph_user_id, user_ids: activity.user_id).first,
            }
        end

      base_activity_data.merge(specialized_data)
    rescue
      nil #activities may become "invalid" in which case the facts/comments/users they refer to
      #are gone.  This  causes errors.  We ignore such activities.
    end
  end
end
