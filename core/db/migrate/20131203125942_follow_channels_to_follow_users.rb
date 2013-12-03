class FollowChannelsToFollowUsers < Mongoid::Migration
  def self.up
    Channel.all.ids.each do |channel_id|
      Resque.enqueue MigrateFollowingChannels, channel_id
    end
  end

  def self.down
  end
end
