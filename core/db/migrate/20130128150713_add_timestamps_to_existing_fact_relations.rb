class AddTimestampsToExistingFactRelations < Mongoid::Migration
  def self.up
    FactRelation.all.ids.each do |id|
      Resque.enqueue(AddTimestampsToFactrelation, id)
    end
  end

  def self.down
  end
end
