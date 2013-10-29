class RemoveFactCreatedActivity < Mongoid::Migration
  def self.up
    ids = Activity.find(action: :created).ids
    ids.each do |id|
      activity = Activity[id]
      activity.delete
    end
  end

  def self.down
  end
end
