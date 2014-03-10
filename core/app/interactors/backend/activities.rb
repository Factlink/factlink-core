module Backend
  module Activities
    extend self

    def activities_older_than(activities_set:, timestamp: nil, count: nil)
      #watch out: don't use defaults other than nil since nill is automatically passed in at the rails controller level.
      timestamp = timestamp || 'inf'
      count = count ? count.to_i : 20
      retrieved_activities = Enumerator.new do |yielder|
        while true
          current =
              activities_set.below(timestamp,
                                   count: count, #count here is merely the batch-size; anything larger than 0 is valid.
                                   reversed: true,
                                   withscores: true)
          if current.none?
            break
          else
            timestamp = current.last[:score]
            current.each { |o| yielder.yield o }
          end
        end
      end.lazy

      retrieved_activities
        .map { |scored_activity| scored_activity_to_dead_activity scored_activity }
        .reject { |o| o.nil? }
        .take(count)
        .to_a
    end

    def scored_activity_to_dead_activity(item: , score:)
      activity = item

      base_activity_data = {
          timestamp: score,
          action: activity.action,
          created_at: activity.created_at.to_time,
          id: activity.id,
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
