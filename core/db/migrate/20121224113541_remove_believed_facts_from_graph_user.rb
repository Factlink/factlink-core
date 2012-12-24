class RemoveBelievedFactsFromGraphUser < Mongoid::Migration
  def self.up
    GraphUser.all.ids.each do |gu_id|
      gu = GraphUser[gu_id]
      [
        :believes_facts, :doubts_facts, :disbelieves_facts
      ].each do|set|
        gu.key[set].del
      end
    end
  end

  def self.down
  end
end
