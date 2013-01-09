require 'redis-aid'

class TopChannels
  include Redis::Aid::Ns(:top_channels)

  def ids
    redis[:handpicked_channels].smembers
  end
end