def create_activity_listeners
  Activity::Listener.class_eval do

    # evidence was added to a fact which you created or expressed your opinion on
    forGraphUser_evidence_was_added = {
      subject_class: "Fact",
      action: [:added_supporting_evidence, :added_weakening_evidence],
      write_ids: lambda {|a| ([a.object.created_by_id]+a.object.opinionated_users.ids).uniq.delete_if {|id| id == a.user_id}}
    }

    register do
      activity_for "GraphUser"
      named :notifications

      # someone followed your channel
      activity subject_class: "Channel", action: 'added_subchannel',
               extra_condition: lambda { |a| a.subject.created_by_id != a.user.id },
               write_ids: lambda { |a| [a.subject.created_by_id] }

      # someone added supporting or weakening evidence
      activity forGraphUser_evidence_was_added

      # you were invited to factlink by this user
      activity subject_class: "GraphUser",
               action: :invites,
               write_ids: lambda { |a| [a.subject_id] }

    end

    register do
      activity_for "GraphUser"
      named :stream_activities

      # someone of whom you follow a channel created a new channel
      activity subject_class: "Channel", action: :created_channel,
               write_ids: lambda { |a| a.subject.created_by.channels.map { |channel| channel.containing_channels.map { |cont_channel| cont_channel.created_by_id }}.flatten.uniq.delete_if { |id| id == a.user_id } }

      # someone added supporting or weakening evidence
      activity forGraphUser_evidence_was_added

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

      # # someone added a fact to a channel which you follow
      # activity subject_class: "Fact",
      #          action: :added_fact_to_channel,
      #          write_ids: lambda { |a| [a.object.containing_channels.map {|ch| ch.created_by_id }.keep_if { |id| id != a.user_id } ] }

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
      activity_for "Fact"
      named :interactions

      activity subject_class: "Fact",
               action: [:created, :believes, :disbelieves, :doubts, :removed_opinions],
               write_ids: lambda { |a| [a.subject.id]}

    end
  end
end

create_activity_listeners
