class RemoveChannelsWithEmptySlug < Mongoid::Migration
  def self.up
    Channel.find(slug_title: '').each do |channel|
      if channel.type == 'channel' # please don't remove streams
        channel.delete
      end
    end
  end

  def self.down
  end
end
