require 'pavlov'

class ActivityListenerCreator
  def followers_for_fact fact
    Queries::Activities::GraphUserIdsFollowingFact.new(fact).call
  end

  def followers_for_sub_comment sub_comment
      if sub_comment.parent_class == 'Comment'
        followers_for_comment sub_comment.parent
      else
        followers_for_fact_relation sub_comment.parent
      end
  end

  def followers_for_comment comment
    Queries::Activities::GraphUserIdsFollowingComments.new([comment]).call
  end

  def followers_for_fact_relation fact_relation
    Queries::Activities::GraphUserIdsFollowingFactRelations.new([fact_relation]).call
  end

  def followers_for_conversation conversation
    conversation.recipients.map { |r| r.graph_user.id }
  end

  def reject_self followers, activity
    followers.reject {|id| id == activity.user_id}
  end

  def create_activity_listeners
    #
    # in the following code, 'you' is anyone in the write_ids
    #

    people_who_follow_sub_comment = lambda { |a| reject_self(followers_for_sub_comment(a.subject), a) }

    people_who_follow_a_fact_which_is_object = lambda { |a| reject_self(followers_for_fact(a.object),a) }

    # evidence was added to a fact which you created or expressed your opinion on
    forGraphUser_evidence_was_added = {
      subject_class: "Fact",
      action: [:added_supporting_evidence, :added_weakening_evidence],
      write_ids: people_who_follow_a_fact_which_is_object
    }

    # someone followed your channel
    forGraphUser_channel_was_followed = {
      subject_class: "Channel",
      action: 'added_subchannel',
      extra_condition: lambda { |a| a.subject.created_by_id != a.user.id },
      write_ids: lambda { |a| [a.subject.created_by_id] }
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

    notification_activities = [
      forGraphUser_channel_was_followed,
      forGraphUser_evidence_was_added,
      forGraphUser_someone_send_you_a_message,
      forGraphUser_someone_send_you_a_reply,
      forGraphUser_comment_was_added,
      forGraphUser_someone_invited_you,
      forGraphUser_someone_added_a_subcomment_to_your_comment_or_fact_relation
    ]

    stream_activities = [
      forGraphUser_channel_was_followed,
      forGraphUser_evidence_was_added,
      forGraphUser_comment_was_added
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

      # someone of whom you follow a channel created a new channel
      activity subject_class: "Channel", action: :created_channel,
               write_ids: lambda { |a| ChannelList.new(a.subject.created_by).channels.map { |channel| channel.containing_channels.map { |cont_channel| cont_channel.created_by_id }}.flatten.uniq.reject { |id| id == a.user_id } }


      # someone added a sub comment
      activity subject_class: "SubComment",
               action: :created_sub_comment,
               write_ids: people_who_follow_a_fact_which_is_object

      # someone believed/disbelieved/doubted your fact
      activity subject_class: "Fact",
               action: [:believes, :doubts, :disbelieves],
               extra_condition: lambda { |a| a.subject.created_by_id != a.user.id },
               write_ids: lambda { |a| [a.subject.created_by_id] }

      # someone added a fact created by you to his channel
      activity subject_class: "Fact",
               action: :added_fact_to_channel,
               extra_condition: lambda { |a| (a.subject.created_by_id != a.user_id) and (a.object.type == 'channel')},
               write_ids: lambda { |a| [a.subject.created_by_id] }

      # someone added a fact to a channel which you follow
      activity subject_class: "Fact",
               action: :added_fact_to_channel,
               write_ids: lambda { |a| [a.object.containing_channels.map {|ch| ch.created_by_id }.select { |id| id != a.user_id } ].flatten }

      # the users first Factlink
      activity subject_class: "Fact",
               action: :added_first_factlink,
               write_ids: lambda { |a| [a.subject.created_by_id] }
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
