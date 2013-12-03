class RemoveChannelUnreadFacts < Mongoid::Migration
  def self.up
    Channel.all.ids.each do |ch_id|
      channel = Channel[ch_id]
      channel.key[:unread_facts].del
    end
  end

  def self.down
  end
end
