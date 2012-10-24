class AddFactToChannelInteractor
  def initialize fact_id, channel_id, options={}
    raise 'Fact_id should be an integer.'    unless /\A\d+\Z/.match fact_id
    raise 'Channel_id should be an integer.' unless /\A\d+\Z/.match channel_id

    @fact_id = fact_id
    @channel_id = channel_id
    @ability = options[:ability]
  end

  def execute
    channel = Channel[@channel_id]

    raise Pavlov::AccessDenied unless @ability.can? :update, channel

    fact = Fact[@fact_id]

    channel.add_fact(fact)
  end
end
