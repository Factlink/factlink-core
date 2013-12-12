class RemoveOldActivities < Mongoid::Migration
  def self.up
    User.all.each do |u|
      Resque.enqueue MigrateRemoveOldActivitiesForUserWorker, u.id.to_s
    end
  end

  def self.down
  end
end
