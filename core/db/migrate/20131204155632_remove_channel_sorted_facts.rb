class RemoveChannelSortedFacts < Mongoid::Migration
  def self.up
    Channel.all.ids.each do |id|
      Channel.key[id][:sorted_cached_facts].del
      Channel.key[id][:sorted_delete_facts].del
    end
  end

  def self.down
  end
end
