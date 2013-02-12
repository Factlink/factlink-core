require 'redis-aid'

class TopChannels
  attr_reader :handpicked_channels_interface

  def initialize nest_key=Nest.new(:top_channels)[:handpicked_channels]
    @handpicked_channels_interface = nest_key
  end

  def members
    ids.map {|id| Channel[id]}
       .compact
       .select {|ch| valid(ch)}
  end

  def add id
    handpicked_channels_interface.sadd id
  end

  def remove id
    handpicked_channels_interface.srem id
  end

  private
  def ids
    handpicked_channels_interface.smembers
  end

  def valid channel
    channel.added_facts.count > 0
  end
end
