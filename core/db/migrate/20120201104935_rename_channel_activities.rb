class RenameChannelActivities < Mongoid::Migration
  def self.up
    say_with_time "migrating activities to match new names/structure" do
      Activity.find(subject_class: FactRelation, action: 'created').each do |a|
        fr = a.subject
        if fr
          a.subject = fr.from_fact
          a.object = fr.fact
          a.action = :"added_#{fr.type}_evidence"
          a.save
        else
          a.delete
        end
      end
      Activity.find(subject_class: Channel, action: 'added').each do |a|
        a.action = :added_subchannel
        a.save
      end
    end
  end

  def self.down
  end
end