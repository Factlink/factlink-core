class FactRelationActivities < Mongoid::Migration
  def self.up
    Resque.enqueue MigrateFactRelationActivitiesWorker
  end

  def self.down
  end
end
