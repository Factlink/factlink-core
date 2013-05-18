require 'pavlov'

class ActivityListenerCreator
  include Pavlov::Helpers
  def followers_for_fact fact
    query :'activities/graph_user_ids_following_fact', fact
  end

  def followers_for_sub_comment sub_comment
      if sub_comment.parent_class == 'Comment'
        followers_for_comment sub_comment.parent
      else
        followers_for_fact_relation sub_comment.parent
      end
  end

  def followers_for_comment comment
    query :'activities/graph_user_ids_following_comments', [comment]
  end

  def followers_for_fact_relation fact_relation
    query :'activities/graph_user_ids_following_fact_relations', [fact_relation]
  end

  def followers_for_conversation conversation
    conversation.recipients.map { |r| r.graph_user.id }
  end

  def followers_for_graph_user graph_user_id
    query :'users/follower_graph_user_ids', graph_user_id
  end

  def channel_followers_of_graph_user graph_user
    ChannelList.new(graph_user).channels
      .map { |channel| channel.containing_channels.to_a }.flatten
      .map { |following_channel| following_channel.created_by_id }.uniq
  end

  def channel_followers_of_graph_user_minus_regular_followers graph_user
    channel_followers_of_graph_user(graph_user) - followers_for_graph_user(graph_user.id)
  end

  def reject_self followers, activity
    followers.reject {|id| id == activity.user_id}
  end

  def select_users_that_see_channels user_ids
    user_ids.select do |id|
      user = GraphUser[id].andand.user
      user && user.features.include?(:sees_channels)
    end
  end

  def create_activity_listeners
    #
    # in the following code, 'you' is anyone in the write_ids
    #

    people_who_follow_sub_comment = lambda { |a| reject_self(followers_for_sub_comment(a.subject), a) }

    people_who_follow_a_fact_which_is_object = lambda { |a| reject_self(followers_for_fact(a.object),a) }

    forGraphUser_someone_added_evidence_to_a_fact_you_follow = {
      subject_class: "Fact",
      action: [:added_supporting_evidence, :added_weakening_evidence],
      write_ids: people_who_follow_a_fact_which_is_object
    }

    forGraphUser_someone_followed_your_channel = {
      subject_class: "Channel",
      action: 'added_subchannel',
      extra_condition: lambda { |a| a.subject.created_by_id != a.user.id and not followers_for_graph_user(a.subject.created_by_id).include?(a.user.id)},
      write_ids: lambda { |a| select_users_that_see_channels([a.subject.created_by_id]) }
    }

    forGraphUser_comment_was_added = {
      subject_class: "Comment",
      action: :created_comment,
      write_ids: people_who_follow_a_fact_which_is_object
    }

    forGraphUser_someone_send_you_a_message = {
      subject_class: "Conversation",
      action: [:created_conversation],
      write_ids: lambda { |a| reject_self(followers_for_conversation(a.subject),a) }
    }

    forGraphUser_someone_send_you_a_reply = {
      subject_class: "Message",
      action: [:replied_message],
      write_ids: lambda { |a| reject_self(followers_for_conversation(a.subject.conversation),a) }
    }

    forGraphUser_someone_invited_you = {
      subject_class: "GraphUser",
      action: :invites,
      write_ids: lambda { |a| [a.subject_id] }
    }

    forGraphUser_someone_added_a_subcomment_to_your_comment_or_fact_relation = {
      subject_class: "SubComment",
      action: :created_sub_comment,
      write_ids: people_who_follow_sub_comment
    }

    forGraphUser_someone_of_whom_you_follow_a_channel_created_a_new_channel = {
      subject_class: "Channel",
      action: :created_channel,
      write_ids: lambda { |a| select_users_that_see_channels(reject_self(channel_followers_of_graph_user_minus_regular_followers(a.subject.created_by),a)) }
    }

    forGraphUser_someone_added_a_subcomment_to_a_fact_you_follow = {
      subject_class: "SubComment",
      action: :created_sub_comment,
      write_ids: people_who_follow_a_fact_which_is_object
    }

    forGraphUser_someone_opinionated_a_fact_you_created = {
      subject_class: "Fact",
      action: [:believes, :doubts, :disbelieves],
      extra_condition: lambda { |a| a.subject.created_by_id != a.user.id },
      write_ids: lambda { |a| [a.subject.created_by_id] }
    }

    forGraphUser_someone_added_a_fact_you_created_to_his_channel = {
      subject_class: "Fact",
      action: :added_fact_to_channel,
      extra_condition: lambda { |a| (a.subject.created_by_id != a.user_id) and (a.object.type == 'channel')},
      write_ids: lambda { |a| [a.subject.created_by_id] }
    }

    forGraphUser_someone_added_a_fact_to_a_channel_you_follow = {
      subject_class: "Fact",
      action: :added_fact_to_channel,
      write_ids: lambda { |a| [a.object.containing_channels.map {|ch| ch.created_by_id }.select { |id| id != a.user_id } ].flatten }
    }

    forGraphUser_you_just_created_your_first_factlink = {
      subject_class: "Fact",
      action: :added_first_factlink,
      write_ids: lambda { |a| [a.subject.created_by_id] }
    }

    forGraphUser_someone_followed_you = {
      subject_class: 'GraphUser',
      action: 'followed_user',
      write_ids: lambda {|a| [a.subject_id]}
    }

    forGraphUser_someone_you_follow_added_a_fact_to_a_channel = {
      subject_class: 'Fact',
      action: :added_fact_to_channel,
      write_ids: lambda {|a| followers_for_graph_user(a.user_id)}
    }

    forGraphUser_someone_you_follow_followed_someone_else = {
      subject_class: 'GraphUser',
      action: 'followed_user',
      write_ids: lambda {|a| followers_for_graph_user(a.user_id) - [a.subject_id]}
    }

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

    stream_activities = [
      forGraphUser_someone_followed_your_channel,
      forGraphUser_someone_added_evidence_to_a_fact_you_follow,
      forGraphUser_comment_was_added,
      forGraphUser_someone_of_whom_you_follow_a_channel_created_a_new_channel,
      forGraphUser_someone_added_a_subcomment_to_a_fact_you_follow,
      forGraphUser_someone_opinionated_a_fact_you_created,
      forGraphUser_someone_added_a_fact_you_created_to_his_channel,
      forGraphUser_someone_added_a_fact_to_a_channel_you_follow,
      forGraphUser_someone_you_follow_added_a_fact_to_a_channel,
      forGraphUser_someone_you_follow_followed_someone_else,
      forGraphUser_you_just_created_your_first_factlink
    ]

    Activity::Listener.register do
      activity_for "GraphUser"
      named :notifications
      notification_activities.each { |a| activity a }
    end

    Activity::Listener.register do
      activity_for "GraphUser"
      named :stream_activities
      stream_activities.each { |a| activity a }
    end

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

    Activity::Listener.register do
      activity_for "Channel"
      named :added_facts

      # someone added a fact created to his channel
      activity subject_class: "Fact",
               action: :added_fact_to_channel,
               write_ids: lambda { |a| [a.object_id] }
    end

    Activity::Listener.register do
      activity_for "Fact"
      named :interactions

      activity subject_class: "Fact",
               action: [:created, :believes, :disbelieves, :doubts, :removed_opinions],
               write_ids: lambda { |a| [a.subject.id]}

    end
  end
end

ActivityListenerCreator.new.create_activity_listeners
