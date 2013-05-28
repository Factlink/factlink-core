require 'pavlov'

class Activity < OurOhm
  class ListenerCreator
    #
    # in the following code, 'you' is anyone in the write_ids
    #
    include Activity::Followers

    def reject_self followers, activity
      followers.reject {|id| id == activity.user_id}
    end

    def select_users_that_see_channels user_ids
      user_ids.select do |id|
        user = GraphUser[id].andand.user
        user && user.features.include?(:sees_channels)
      end
    end

    def people_who_follow_sub_comment
      lambda { |a| reject_self(followers_for_sub_comment(a.subject), a) }
    end

    def people_who_follow_a_fact_which_is_object
      lambda { |a| reject_self(followers_for_fact(a.object),a) }
    end

    def forGraphUser_someone_added_evidence_to_a_fact_you_follow
      {
        subject_class: "Fact",
        action: [:added_supporting_evidence, :added_weakening_evidence],
        write_ids: people_who_follow_a_fact_which_is_object
      }
    end

    def forGraphUser_someone_followed_your_channel
      {
        subject_class: "Channel",
        action: 'added_subchannel',
        extra_condition: lambda { |a| a.subject.created_by_id != a.user.id and not followers_for_graph_user(a.subject.created_by_id).include?(a.user.id)},
        write_ids: lambda { |a| select_users_that_see_channels([a.subject.created_by_id]) }
      }
    end

    def forGraphUser_comment_was_added
      {
        subject_class: "Comment",
        action: :created_comment,
        write_ids: people_who_follow_a_fact_which_is_object
      }
    end

    def forGraphUser_someone_send_you_a_message
      {
        subject_class: "Conversation",
        action: [:created_conversation],
        write_ids: lambda { |a| reject_self(followers_for_conversation(a.subject),a) }
      }
    end

    def forGraphUser_someone_send_you_a_reply
      {
        subject_class: "Message",
        action: [:replied_message],
        write_ids: lambda { |a| reject_self(followers_for_conversation(a.subject.conversation),a) }
      }
    end

    def forGraphUser_someone_invited_you
      {
        subject_class: "GraphUser",
        action: :invites,
        write_ids: lambda { |a| [a.subject_id] }
      }
    end

    def forGraphUser_someone_added_a_subcomment_to_your_comment_or_fact_relation
      {
        subject_class: "SubComment",
        action: :created_sub_comment,
        write_ids: people_who_follow_sub_comment
      }
    end

    def forGraphUser_someone_of_whom_you_follow_a_channel_created_a_new_channel
      {
        subject_class: "Channel",
        action: :created_channel,
        write_ids: lambda { |a| select_users_that_see_channels(reject_self(channel_followers_of_graph_user_minus_regular_followers(a.subject.created_by),a)) }
      }
    end

    def forGraphUser_someone_added_a_subcomment_to_a_fact_you_follow
      {
        subject_class: "SubComment",
        action: :created_sub_comment,
        write_ids: people_who_follow_a_fact_which_is_object
      }
    end

    def forGraphUser_someone_opinionated_a_fact_you_created
      {
        subject_class: "Fact",
        action: [:believes, :doubts, :disbelieves],
        extra_condition: lambda { |a| a.subject.created_by_id != a.user.id },
        write_ids: lambda { |a| [a.subject.created_by_id] }
      }
    end

    def forGraphUser_someone_added_a_fact_you_created_to_his_channel
      {
        subject_class: "Fact",
        action: :added_fact_to_channel,
        extra_condition: lambda { |a| (a.subject.created_by_id != a.user_id) and (a.object.type == 'channel')},
        write_ids: lambda { |a| [a.subject.created_by_id] }
      }
    end

    def forGraphUser_someone_added_a_fact_to_a_channel_you_follow
      {
        subject_class: "Fact",
        action: :added_fact_to_channel,
        write_ids: lambda { |a| [a.object.containing_channels.map {|ch| ch.created_by_id }.select { |id| id != a.user_id } ].flatten }
      }
    end

    def forGraphUser_you_just_created_your_first_factlink
      {
        subject_class: "Fact",
        action: :added_first_factlink,
        write_ids: lambda { |a| [a.subject.created_by_id] }
      }
    end

    def forGraphUser_someone_followed_you
      {
        subject_class: 'GraphUser',
        action: 'followed_user',
        write_ids: lambda {|a| [a.subject_id]}
      }
    end

    def create_activity_listeners
      Activity::Listener.reset
      # TODO clear activity listeners for develop
      create_notification_activities
      create_stream_activities
      create_obsolete_activities
    end

    def create_notification_activities
      notification_activities = [
        forGraphUser_someone_followed_your_channel,
        forGraphUser_someone_added_evidence_to_a_fact_you_follow,
        forGraphUser_someone_send_you_a_message,
        forGraphUser_someone_send_you_a_reply,
        forGraphUser_comment_was_added,
        forGraphUser_someone_invited_you,
        forGraphUser_someone_added_a_subcomment_to_your_comment_or_fact_relation,
        forGraphUser_someone_followed_you
      ]
      Activity::Listener.register do
        activity_for "GraphUser"
        named :notifications
        notification_activities.each { |a| activity a }
      end
    end

    def create_stream_activities
      Activity::Listener.register_listener Activity::Listener::Stream.new

      stream_activities = [
        forGraphUser_someone_followed_your_channel,
        forGraphUser_someone_added_evidence_to_a_fact_you_follow,
        forGraphUser_comment_was_added,
        forGraphUser_someone_of_whom_you_follow_a_channel_created_a_new_channel,
        forGraphUser_someone_added_a_subcomment_to_a_fact_you_follow,
        forGraphUser_someone_opinionated_a_fact_you_created,
        forGraphUser_someone_added_a_fact_you_created_to_his_channel,
        forGraphUser_someone_added_a_fact_to_a_channel_you_follow,
        forGraphUser_you_just_created_your_first_factlink
      ]

      Activity::Listener.register do
        activity_for "GraphUser"
        named :stream_activities
        stream_activities.each { |a| activity a }
      end
    end

    def create_obsolete_activities
      # This was used for the activities tab of the channel
      # however, we removed access to this view a long time ago
      # Although we have been talking of bringing this back..!
      create_channel_activities
      # This is used for adding channels in the tour, and can be
      # Removed as soon as we switch to following people in the tour
      create_channel_added_facts
      # I don't know why this was ever added, is not used as far
      # as I can see
      create_fact_interactions
    end

    def create_channel_activities
      Activity::Listener.register do
        activity_for "Channel"
        named :activities

        activity subject_class: "Channel",
                 action: 'added_subchannel',
                 write_ids: lambda { |a| [a.subject_id] }

        activity object_class: "Fact",
                 action: [:added_supporting_evidence, :added_weakening_evidence],
                 write_ids: lambda { |a| a.object.channels.ids }
      end
    end
    def create_channel_added_facts
      Activity::Listener.register do
        activity_for "Channel"
        named :added_facts

        # someone added a fact created to his channel
        activity subject_class: "Fact",
                 action: :added_fact_to_channel,
                 write_ids: lambda { |a| [a.object_id] }
      end
    end

    def create_fact_interactions
      Activity::Listener.register do
        activity_for "Fact"
        named :interactions

        activity subject_class: "Fact",
                 action: [:created, :believes, :disbelieves, :doubts, :removed_opinions],
                 write_ids: lambda { |a| [a.subject.id]}

      end
    end
  end
end

Activity::ListenerCreator.new.create_activity_listeners
