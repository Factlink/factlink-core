class RemoveEmptyTopics < Mongoid::Migration
  def self.up
    Resque.enqueue(Janitor::RemoveTopicsWithoutChannels)
  end

  def self.down
  end
end