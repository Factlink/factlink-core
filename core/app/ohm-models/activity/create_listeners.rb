def create_activity_listeners
  Activity::Listener.class_eval do

    register do
      activity_for "GraphUser"
      named :notifications

      activity subject_class: "Channel", action: 'added_subchannel',
               extra_condition: lambda { |a| a.subject.created_by_id != a.user.id },
               write_ids: lambda { |a| [a.subject.created_by_id] }

      activity subject_class: "Fact",
               action: [:added_supporting_evidence, :added_weakening_evidence],
               extra_condition: lambda { |a| a.object.created_by_id != a.user_id },
               write_ids: lambda {|a| [a.object.created_by_id]}

      activity subject_class: "Fact",
               action: [:believes, :doubts, :disbelieves],
               extra_condition: lambda { |a| a.subject.created_by_id != a.user.id },
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
      activity_for "Fact"
      named :interactions

      activity subject_class: "Fact",
               action: [:believes, :disbelieves, :doubts, :removed_opinions],
               write_ids: lambda { |a| [a.subject.id]}
                              
    end
  end
end

create_activity_listeners