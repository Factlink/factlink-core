class InitializeSortedCreatedFacts < Mongoid::Migration
  def self.up
    GraphUser.all.ids.each do |id|
      Resque.enqueue CreateSortedCreatedFacts, id
    end
  end

  def self.down
  end
end
