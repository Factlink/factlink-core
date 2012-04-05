class RemoveDuplicateFactRelations < Mongoid::Migration
  def self.up
    Fact.all.each do |fact|
      factArray = Array.new
      fact.supporting_facts.each do |supporting|
        if factArray[supporting.from_fact_id.to_i] == nil
          factArray[supporting.from_fact_id.to_i] = true;
        else
          supporting.delete
        end
      end
      factArray = Array.new
      fact.weakening_facts.each do |weakening|
        if factArray[weakening.from_fact_id.to_i] == nil
          factArray[weakening.from_fact_id.to_i] = true;
        else
          weakening.delete
        end
      end
    end
  end

  def self.down
  end
end