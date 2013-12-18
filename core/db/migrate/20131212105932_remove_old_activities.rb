class RemoveOldActivities < Mongoid::Migration
  def self.up
    Activity.all.ids.each do |id|
      a = Activity[id]
      unless a.still_valid?
        a.delete
      end
    end

    GraphUser.all.ids.each do |graph_user_id|
      Resque.enqueue MigrateRemoveOldActivitiesForUserWorker, graph_user_id
    end
  end

  def self.down
  end
end
