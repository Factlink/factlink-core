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
            comment = Backend::Comments.by_ids(ids: [activity.subject_id.to_s]).first
            {
                fact: Backend::Facts.get(fact_id: activity.subject.fact_data.fact_id),
                comment: comment,
                user: comment.created_by,
            }
          when "created_sub_comment"
            sub_comment = Backend::SubComments::dead_for(activity.subject)
            {
                fact: Backend::Facts.get(fact_id: activity.subject.parent.fact_data.fact_id),
                comment: Backend::Comments.by_ids(ids: [activity.subject.parent_id.to_s]).first,
                sub_comment: sub_comment,
                user: sub_comment.created_by,
            }
          when "followed_user"
            {
                followed_user: Backend::Users.by_ids(by: :graph_user_id, user_ids: activity.subject_id).first,
                user: Backend::Users.by_ids(by: :graph_user_id, user_ids: activity.user_id).first,
            }
          end

      base_activity_data.merge(specialized_data)
    rescue
      nil #activities may become "invalid" in which case the facts/comments/users they refer to
      #are gone.  This  causes errors.  We ignore such activities.
    end

    def add_activities_to_follower_stream(followed_user_graph_user_id:, current_graph_user_id:)
      activities_set = GraphUser[followed_user_graph_user_id].own_activities

      activities = activities_set.below('inf',
                    count: 7,
                    reversed: true,
                    withscores: false).compact

      current_graph_user = GraphUser[current_graph_user_id]

      activities.each do |activity|
        activity.add_to_list_with_score current_graph_user.stream_activities
      end
    end

    def create(graph_user_id:, action:, subject:, time:, send_mails:)
      activity = Activity.create(user_id: graph_user_id, action: action, subject: subject,
        created_at: time.utc.to_s)

      Resque.enqueue(ProcessActivity, activity.id)
      send_mail_for_activity activity: activity if send_mails

      activity
    end

    private

    def send_mail_for_activity(activity:)
      listeners = Activity::Listener.all[{class: "GraphUser", list: :notifications}]

      graph_user_ids = listeners.map do |listener|
          listener.add_to(activity)
        end.flatten

      recipients = UserNotification.users_receiving('mailed_notifications')
                                   .any_in(graph_user_id: graph_user_ids)

      recipients.each do |user|
        Resque.enqueue SendActivityMailToUser, user.id, activity.id
      end
    end
  end
end
