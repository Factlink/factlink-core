class MoveAwaySubchannelsWithOtherTitle
  def initialize id
    @id = id
  end

  def perform
    subchannels_with_other_title.each do |ch|
      reassign_subchannel ch
    end
  end

  def subchannels_with_other_title
    channel.contained_channels.to_a
           .reject {|ch| ch.slug_title == channel.slug_title}
  end
  def reassign_subchannel subchannel
    Commands::Channels::RemoveSubchannel.new(channel, subchannel).call
    Commands::Channels::Follow.new(subchannel, current_user: channel_user).call
  end
  def channel
    @channel ||= Channel[@id]
  end
  def channel_user
    channel.created_by.user
  end

  def self.perform *args
    new(*args).perform
  end
end
