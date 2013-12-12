class RemoveOldActivities < Mongoid::Migration
  def self.up
    Activity.all.ids.each do |id|
      a = Activity[id]
      unless a.still_valid?
        a.delete
      end
    end

    User.all.ids.each do |id|
      Resque.enqueue MigrateRemoveOldActivitiesForUserWorker, id
    end
  end

  def self.down
  end
end
