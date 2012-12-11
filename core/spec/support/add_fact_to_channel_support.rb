module AddFactToChannelSupport
  def add_fact_to_channel fact, channel
    Interactors::Channels::AddFact.new(fact, channel, no_current_user: true).execute
  end
end
