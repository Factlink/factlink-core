class RemoveFactRelationSets < Mongoid::Migration
  def self.up
    Resque.enqueue MigrateRemoveFactRelationSetsWorker
  end

  def self.down
  end
end
