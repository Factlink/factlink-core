class ChannelForFact

  def initialize(channel,fact)
    @channel = channel
    @fact = fact
  end
  
  def to_hash
    @channel.to_hash.merge({
      :created_by => created_by,
      :checked => @channel.include?(@fact)
    })
  end

  delegate :id, :title, :to => :@channel

  def created_by
    @channel.created_by.user.username
  end

  def checked_attribute
    include?(@fact) ? 'checked="checked"' : ''
  end

end
