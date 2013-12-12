class RemoveOldActivities < Mongoid::Migration
  def self.up
    Activity.all.each do |a|
      unless a.still_valid?
        a.delete
      end
    end

    User.all.each do |u|
      Resque.enqueue MigrateRemoveOldActivitiesForUserWorker, u.id.to_s
    end
  end

  def self.down
  end
end
