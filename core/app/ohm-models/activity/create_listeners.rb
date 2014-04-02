require 'pavlov'

class Activity < OurOhm
  class ListenerCreator
    #
    # in the following code, 'you' is anyone in the write_ids
    #

    def reject_self followers, activity
      followers.reject {|id| id == activity.user_id}
    end

    def people_who_follow_sub_comment
      ->(a) { reject_self(Backend::Followers.followers_for_sub_comments([a.subject]), a) }
    end

    def people_who_follow_user_of_activity
      ->(a) { reject_self(Backend::UserFollowers.follower_ids(followee_id: a.user_id), a) }
    end

    # notifications, stream_activities
    def forGraphUser_comment_was_added_to_a_fact_you_follow
      {
        subject_class: "Comment",
        action: :created_comment,
        write_ids: ->(a) { reject_self(Backend::Followers.followers_for_fact(a.subject.fact_data.fact_id),a) }
      }
    end

    # stream_activities
    def forGraphUser_follower_created_comment
      {
        subject_class: "Comment",
        action: :created_comment,
        write_ids: people_who_follow_user_of_activity
      }
    end

    # notifications
    def forGraphUser_someone_added_a_subcomment_to_your_comment
      {
        subject_class: "SubComment",
        action: :created_sub_comment,
        write_ids: people_who_follow_sub_comment
      }
    end

    # stream_activities
    def forGraphUser_someone_added_a_subcomment_to_a_fact_you_follow
      {
        subject_class: "SubComment",
        action: :created_sub_comment,
        write_ids: ->(a) { reject_self(Backend::Followers.followers_for_fact(a.subject.parent.fact_data.fact_id),a) }
      }
    end

    # stream_activities
    def forGraphUser_follower_created_sub_comment
      {
        subject_class: "SubComment",
        action: :created_sub_comment,
        write_ids: people_who_follow_user_of_activity
      }
    end

    # notifications
    def forGraphUser_someone_followed_you
      {
        subject_class: 'GraphUser',
        action: 'followed_user',
        write_ids: ->(a) { [a.subject_id]}
      }
    end

    def followed_someone_else
      # If you follow someone, you get activities when they follow someone,
      # except when they follow you
      {
        subject_class: 'GraphUser',
        action: 'followed_user',
        write_ids: ->(a) { Backend::UserFollowers.follower_ids(followee_id: a.user_id) - [a.subject_id] }
      }
    end

    def create_activity_listeners
      Activity::Listener.reset
      # TODO clear activity listeners for develop
      create_notification_activities
      create_stream_activities
      create_global_all_activities
    end

    def create_notification_activities
      # NOTE: Please update the tags above and in _activity.json.jbuilder when changing this!!
      notification_activities = [
        forGraphUser_comment_was_added_to_a_fact_you_follow,
        forGraphUser_someone_added_a_subcomment_to_your_comment,
        forGraphUser_someone_followed_you
      ]

      notification_activities.map{ |a| a[:action] }.flatten.map(&:to_s).each do |action|
        unless Activity.valid_actions_in_notifications.include? action
          fail "Invalid activity action for notifications: #{action}"
        end
      end

      Activity::Listener.register do
        activity_for "GraphUser"
        named :notifications
        notification_activities.each { |a| activity a }
      end
    end

    def create_stream_activities
      # NOTE: Please update the tags above and in _activity.json.jbuilder when changing this!!
      stream_activities = [
        followed_someone_else,
        forGraphUser_comment_was_added_to_a_fact_you_follow,
        forGraphUser_someone_added_a_subcomment_to_a_fact_you_follow,
        forGraphUser_follower_created_comment,
        forGraphUser_follower_created_sub_comment,
      ]

      stream_activities.map{ |a| a[:action] }.flatten.map(&:to_s).each do |action|
        unless Activity.valid_actions_in_stream_activities.include? action
          fail "Invalid activity action for stream: #{action}"
        end
      end

      Activity::Listener.register do
        activity_for "GraphUser"
        named :stream_activities
        stream_activities.each { |a| activity a }
      end

      Activity::Listener.register do
        activity_for "GraphUser"
        named :own_activities
        stream_activities.each do |a|
          activity a.merge({
            write_ids: ->(a) {[a.user_id]}
          })
        end
      end

    end

    def create_global_all_activities
      write_ids = ->(a) { [0] } # irrelevant, fake id; GlobalFeed is a singleton.

      Activity::Listener.register do
        activity_for "GlobalFeed"
        named :all_activities
        activity subject_class: "Comment",
                 action: :created_comment,
                 write_ids: write_ids
        activity subject_class: "SubComment",
                 action: :created_sub_comment,
                 write_ids: write_ids
      end

    end
  end
end
