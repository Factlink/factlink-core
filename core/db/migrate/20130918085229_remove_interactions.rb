class RemoveInteractions < Mongoid::Migration
  def self.up
    Fact.all.ids.each do |id|
      Fact[id].key['interactions'].del
    end
  end

  def self.down
  end
end
