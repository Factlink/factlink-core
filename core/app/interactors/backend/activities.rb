module Backend
  module Activities
    extend self

    def get(activity_id:)
      dead(Activity[activity_id])
    end

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

    private def scored_activity_to_dead_activity(item: , score:)
      dead_activity = dead(item)
      return nil if dead_activity.nil?

      dead_activity.merge(timestamp: score)
    end

    private def dead(activity)
      return nil unless activity.still_valid?

      base_activity_data = {
          action: activity.action,
          created_at: activity.created_at.to_time,
          id: activity.id,
      }
      specialized_data =
          case activity.action
          when "created_comment"
            comment = Backend::Comments.by_ids(ids: [activity.subject_id.to_s], current_user_id: nil).first
            {
                fact: Backend::Facts.get(fact_id: activity.subject.fact_data.fact_id),
                comment: comment,
                user: comment.created_by,
            }
          when "created_sub_comment"
            sub_comment = Backend::SubComments::dead_for(activity.subject)
            {
                fact: Backend::Facts.get(fact_id: activity.subject.parent.fact_data.fact_id),
                comment: Backend::Comments.by_ids(ids: [activity.subject.parent_id.to_s], current_user_id: nil).first,
                sub_comment: sub_comment,
                user: sub_comment.created_by,
            }
          when "followed_user"
            {
                followed_user: Backend::Users.by_ids(user_ids: activity.subject_id).first,
                user: Backend::Users.by_ids(user_ids: activity.user_id).first,
            }
          end

      base_activity_data.merge(specialized_data)
    rescue
      nil #activities may become "invalid" in which case the facts/comments/users they refer to
      #are gone.  This  causes errors.  We ignore such activities.
    end

    def add_activities_to_follower_stream(followed_user_id:, current_user_id:)
      activities_set = User.where(id: followed_user_id).first.own_activities

      activities = activities_set.below('inf',
                    count: 7,
                    reversed: true,
                    withscores: false).compact

      current_user = User.where(id: current_user_id).first

      activities.each do |activity|
        activity.add_to_list_with_score current_user.stream_activities
      end
    end

    def create(user_id:, action:, subject: nil, subject_id: nil, subject_class: nil, time:, send_mails:)
      if subject
        subject_id = subject.id.to_s
        subject_class = subject.class.to_s
      elsif not (subject_id && subject_class)
        raise "INVALID SUBJECT"
      end
      activity = Activity.create \
        user_id: user_id,
        action: action,
        subject_id: subject_id,
        subject_class: subject_class,
        created_at: time.utc.to_s

      Resque.enqueue(ProcessActivity, activity.id)
      send_mail_for_activity activity: activity if send_mails

      nil
    end

    private

    def send_mail_for_activity(activity:)
      listeners = Activity::Listener.all[{class: "User", list: :notifications}]

      graph_user_ids = listeners.map do |listener|
          listener.add_to(activity)
        end.flatten

      recipients = Backend::Notifications.users_receiving(type: 'mailed_notifications')
                                         .where(graph_user_id: graph_user_ids)

      recipients.each do |user|
        Resque.enqueue SendActivityMailToUser, user.id, activity.id
      end
    end
  end
end
