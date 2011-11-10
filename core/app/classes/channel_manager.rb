class ChannelForFact

  def initialize(channel,fact)
    @channel = channel
    @fact = fact
  end
  
  def to_hash
    @channel.to_hash.merge({
      :created_by => @channel.created_by.user.username,
      :checked => @channel.include?(@fact)
    })
  end

  private
     def method_missing(method, *args, &block)
       @channel.send(method, *args, &block)
     end  
end

class ChannelManager
  def initialize(gu)
    @gu = gu
  end
  
  def editable_channel_hash_for(fact)
    @channels = @gu.channels.to_a
    @channels.reject! { |channel| ! channel.editable? }
    @channels.map {|ch| ChannelForFact.new(ch,fact)}
  end
end
