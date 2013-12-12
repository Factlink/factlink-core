class GoodbyeSupportingWeakening < Mongoid::Migration
  def self.up
    Resque.enqueue MigrateSupportingWeakeningFactRelationWorker
  end

  def self.down
  end
end
