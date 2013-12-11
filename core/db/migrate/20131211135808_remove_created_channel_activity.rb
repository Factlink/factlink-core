class RemoveCreatedChannelActivity < Mongoid::Migration
  def self.up
    Resque.enqueue MigrateThrowAwayActivities
  end

  def self.down
  end
end
