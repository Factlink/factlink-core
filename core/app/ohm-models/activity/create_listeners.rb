require 'pavlov'

class ActivityListenerCreator
  def self.followers_for_fact fact
    Queries::Activities::GraphUserIdsFollowingFact.new(fact).call
  end

  def self.followers_for_sub_comment sub_comment
      if sub_comment.parent_class == 'Comment'
        Queries::Activities::GraphUserIdsFollowingComments.new([sub_comment.parent]).call
      else
        Queries::Activities::GraphUserIdsFollowingFactRelations.new([sub_comment.parent]).call
      end
  end

  def self.create_activity_listeners
    Activity::Listener.class_eval do
      people_who_follow_a_fact = lambda { |a| ActivityListenerCreator.followers_for_fact(a.object).reject {|id| id == a.user_id} }

      people_who_follow_sub_comment = lambda { |a|
        ActivityListenerCreator.followers_for_sub_comment(a.subject).reject { |id| id == a.user_id }
      }

      # evidence was added to a fact which you created or expressed your opinion on
      forGraphUser_evidence_was_added = {
        subject_class: "Fact",
        action: [:added_supporting_evidence, :added_weakening_evidence],
        write_ids: people_who_follow_a_fact
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
        write_ids: people_who_follow_a_fact
      }

      register do
        activity_for "GraphUser"
        named :notifications

        # someone followed your channel
        activity forGraphUser_channel_was_followed

        # someone added supporting or weakening evidence
        activity forGraphUser_evidence_was_added

        # you were invited to factlink by this user
        activity subject_class: "GraphUser",
                 action: :invites,
                 write_ids: lambda { |a| [a.subject_id] }

        # someone sent you a conversation or a reply
        activity subject_class: "Conversation",
                 action: [:created_conversation],
                 write_ids: lambda { |a| a.subject.recipients.map { |r| r.graph_user.id }.reject { |id| id == a.user_id } }

        activity subject_class: "Message",
                 action: [:replied_message],
                 write_ids: lambda { |a| a.subject.conversation.recipients.map { |r| r.graph_user.id }.reject { |id| id == a.user_id } }

        # someone added a comment
        activity forGraphUser_comment_was_added

        # someone added a sub comment
        activity subject_class: "SubComment",
                 action: :created_sub_comment,
                 write_ids: people_who_follow_sub_comment
      end

      register do
        activity_for "GraphUser"
        named :stream_activities

        # someone of whom you follow a channel created a new channel
        activity subject_class: "Channel", action: :created_channel,
                 write_ids: lambda { |a| ChannelList.new(a.subject.created_by).channels.map { |channel| channel.containing_channels.map { |cont_channel| cont_channel.created_by_id }}.flatten.uniq.reject { |id| id == a.user_id } }

        # someone followed your channel
        activity forGraphUser_channel_was_followed

        # someone added supporting or weakening evidence
        activity forGraphUser_evidence_was_added

        # someone added a comment
        activity forGraphUser_comment_was_added

        # someone added a sub comment
        activity subject_class: "SubComment",
                 action: :created_sub_comment,
                 write_ids: people_who_follow_a_fact

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

      register do
        activity_for "Channel"
        named :activities

        activity subject_class: "Channel",
                 action: 'added_subchannel',
                 write_ids: lambda { |a| [a.subject_id] }

        activity object_class: "Fact",
                 action: [:added_supporting_evidence, :added_weakening_evidence],
                 write_ids: lambda { |a| a.object.channels.ids }
      end

      register do
        activity_for "Channel"
        named :added_facts

        # someone added a fact created to his channel
        activity subject_class: "Fact",
                 action: :added_fact_to_channel,
                 write_ids: lambda { |a| [a.object_id] }
      end

      register do
        activity_for "Fact"
        named :interactions

        activity subject_class: "Fact",
                 action: [:created, :believes, :disbelieves, :doubts, :removed_opinions],
                 write_ids: lambda { |a| [a.subject.id]}

      end
    end
  end
end

ActivityListenerCreator.create_activity_listeners
