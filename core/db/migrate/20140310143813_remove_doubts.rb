class RemoveDoubts < Mongoid::Migration
  def self.up
    Fact.ids.each do |id|
      Nest.new('Fact')[id]['people_doubts'].del
    end
  end

  def self.down
  end
end
