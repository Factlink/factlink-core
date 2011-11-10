class ChannelManager
  def initialize(gu)
    @gu = gu
  end
  
  def editable_channel_hash_for(fact)
    @channels = @gu.channels.to_a
    
    @channels.reject! { |channel| ! channel.editable? }
    
    @channels.map do |channel|
      channel.to_hash.merge({
        :created_by => channel.created_by.user.username,
        :checked => channel.include?(@fact)
      })
    end
  end
  
end
