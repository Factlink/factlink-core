class RemoveAddedSubchannelActivities < Mongoid::Migration
  def self.up
    ids = Activity.find(action: :added_subchannel).ids
    ids.each do |id|
      activity = Activity[id]
      activity.delete
    end
  end

  def self.down
  end
end
