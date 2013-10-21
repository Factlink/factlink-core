class RemoveNonRealChannels < Mongoid::Migration
  def self.up
    GraphUser.all.ids.each do |id|
      gu = GraphUser[id]
      channel_list = ChannelList.new(gu)
      non_real_channels = channel_list.channels.select do |ch|
        type = ch.key.hget('_type')
        ["Channel::UserStream", "Channel::CreatedFacts"].include? type
      end

      non_real_channels.each { |ch| ch.delete }
    end
  end

  def self.down
  end
end
