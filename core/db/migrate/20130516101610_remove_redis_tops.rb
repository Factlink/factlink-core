class RemoveRedisTops < Mongoid::Migration
  def self.up
    Topic.redis[:top].del
    Fact.key[:top_facts].del
  end

  def self.down
  end
end
