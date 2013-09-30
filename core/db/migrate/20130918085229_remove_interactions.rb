class RemoveInteractions < Mongoid::Migration
  def self.up
    Fact.all.ids.each do |id|
      Nest.new('Basefact')[id]['interactions'].del
    end
  end

  def self.down
  end
end
