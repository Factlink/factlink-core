require 'redis-aid'

class TopChannels
  include Redis::Aid::Ns(:top_channels)

  def ids
    handpicked_channels_interface.smembers
  end

  def add_id id
    handpicked_channels_interface.sadd id
  end

  def handpicked_channels_interface
    redis[:handpicked_channels]
  end
end
