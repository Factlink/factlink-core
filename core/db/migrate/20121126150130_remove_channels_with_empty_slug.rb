class RemoveChannelsWithEmptySlug < Mongoid::Migration
  def self.up
    Channel.find(slug_title: '').each do |channel|
      channel.real_delete
    end
  end

  def self.down
  end
end
