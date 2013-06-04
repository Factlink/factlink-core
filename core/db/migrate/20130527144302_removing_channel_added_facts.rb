class RemovingChannelAddedFacts < Mongoid::Migration
  def self.up
    Channel.all.each do |channel|
      channel.key[:added_facts].del
    end
  end

  def self.down
  end
end
