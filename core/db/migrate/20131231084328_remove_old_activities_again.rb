class RemoveOldActivitiesAgain < Mongoid::Migration
  def self.up
    Resque.enqueue CleanupActivitiesWorker
  end

  def self.down
  end
end
