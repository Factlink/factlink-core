class RemoveFactRelationCredibility < Mongoid::Migration
  def self.up
    Resque.enqueue(RemoveFactRelationCredibilityJob)
  end

  def self.down
  end
end
