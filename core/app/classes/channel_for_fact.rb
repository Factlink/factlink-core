class ChannelForFact

  def initialize(channel,fact,created_by_username=nil)
    @channel = channel
    @fact = fact
    @created_by_username=created_by_username
  end

  def to_hash
    @channel.to_hash.merge({
      :created_by => created_by,
      :checked => @channel.include?(@fact)
    })
  end

  delegate :id, :title, :to => :@channel

  def created_by
    @created_by_username ||@channel.created_by.user.username
  end

  def checked_attribute
    @channel.include?(@fact) ? 'checked="checked"' : ''
  end

end
