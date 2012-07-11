class RemoveEmptyFacts < Mongoid::Migration
  def self.up
    remove_all_with_displaystring nil
    0.upto(20) do |nr_of_spaces|
      remove_all_with_displaystring ' '*nr_of_spaces
    end
  end

  def self.remove_all_with_displaystring(displaystring)
    FactData.where(displaystring: displaystring).each do |fd|
      fd.fact.andand.delete
    end
  end

  def self.down
  end
end