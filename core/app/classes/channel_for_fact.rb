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
