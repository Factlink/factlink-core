class RemoveOldActivitiesAgain < Mongoid::Migration
  def self.up
    Resque.enqueue CleanupActivitiesWorker

    GraphUser.all.ids.each do |graph_user_id|
      Resque.enqueue MigrateRemoveOldActivitiesForUserWorker, graph_user_id
    end
  end

  def self.down
  end
end
