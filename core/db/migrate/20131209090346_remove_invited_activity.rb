class RemoveInvitedActivity < Mongoid::Migration
  def self.up
    Activity.find(action: :invites).ids.each do |activity_id|
      Activity[activity_id].delete
    end
  end

  def self.down
  end
end
