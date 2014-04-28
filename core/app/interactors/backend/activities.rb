module Backend
  module Activities
    extend self

    def get(activity_id:)
      dead(Activity.find(activity_id))
    end

    def global(newest_timestamp:, count:)
      relation = Activity.where(action: %w(created_comment created_sub_comment))

      feed relation: relation, newest_timestamp: newest_timestamp, count: count
    end

    def global_discussions(newest_timestamp:, count:)
      relation = Activity.where(action: 'created_fact')

      feed relation: relation, newest_timestamp: newest_timestamp, count: count
    end

    def users(newest_timestamp:, username: username)
      user = User.where(username: username).first
      relation = Activity.where(action: %w(created_comment created_sub_comment followed_user), user_id: user.id)

      feed relation: relation, newest_timestamp: newest_timestamp
    end

    def personal(newest_timestamp:, user_id:)
      relation = Activity
        .joins("
          LEFT JOIN sub_comments ON sub_comments.id = activities.subject_id AND activities.subject_type = 'SubComment'
          LEFT JOIN comments ON comments.id = sub_comments.parent_id OR (comments.id = activities.subject_id AND activities.subject_type = 'Comment')
          LEFT JOIN fact_data_interestings ON fact_data_interestings.fact_data_id = comments.fact_data_id
          LEFT JOIN followings ON followings.followee_id = activities.user_id
        ")
        .where('fact_data_interestings.user_id = ? OR followings.follower_id = ?', user_id, user_id)
        .where(action: %w(created_comment created_sub_comment followed_user))

      feed relation: relation, newest_timestamp: newest_timestamp
    end

    private def feed(relation:, newest_timestamp:, count: 20)
      newest_timestamp ||= Time.now

      relation.where("activities.created_at <= ?", newest_timestamp)
              .order('activities.created_at DESC')
              .limit(count)
              .map(&method(:dead))
    end

    private def dead(activity)
      return nil unless activity.still_valid?

      base_activity_data = {
          action: activity.action,
          created_at: activity.created_at.to_time,
          id: activity.id,
          timestamp: activity.created_at.utc.to_s,
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
          when "created_fact"
            {
                fact: Backend::Facts.get(fact_id: activity.subject_id.to_s),
                user: Backend::Users.by_ids(user_ids: [activity.user_id]).first
            }
          end

      base_activity_data.merge(specialized_data)
    rescue StandardError => e
      raise e if Rails.env.test? || Rails.env.development?
      nil #activities may become "invalid" in which case the facts/comments/users they refer to
      #are gone.  This  causes errors.  We ignore such activities.
    end

    def create(user_id:, action:, subject: nil, time:, send_mails:)
      activity = Activity.new
      activity.user_id = user_id
      activity.action = action.to_s
      activity.subject = subject
      activity.created_at = time.utc
      activity.updated_at = time.utc
      activity.save!

      send_mail_for_activity activity: activity if send_mails

      nil
    end

    private

    def send_mail_for_activity(activity:)
      case activity.action.to_s
      when "created_comment"
        user_ids = Backend::Followers.followers_for_fact_id(activity.subject.fact_data.fact_id)
      when "created_sub_comment"
        user_ids = Backend::Followers.followers_for_fact_id(activity.subject.parent.fact_data.fact_id)
      when "followed_user"
        user_ids = [activity.subject_id]
      else
        user_ids = []
      end

      user_ids = user_ids.reject {|id| id.to_s == activity.user_id.to_s }

      recipients = Backend::Notifications.users_receiving(type: 'mailed_notifications')
                                         .where(id: user_ids)

      recipients.each do |user|
        Resque.enqueue SendActivityMailToUser, user.id, activity.id
      end
    end
  end
end
