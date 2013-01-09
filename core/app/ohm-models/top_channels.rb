require 'redis-aid'

class TopChannels
  include Redis::Aid::Ns(:top_channels)

  def ids
    handpicked_channels_interface.smembers
  end

  def add *ids
    handpicked_channels_interface.sadd *ids
  end

  def handpicked_channels_interface
    redis[:handpicked_channels]
  end
end
