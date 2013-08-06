module AddFactToChannelSupport
  def add_fact_to_channel fact, channel
    Interactors::Channels::AddFact.new(fact: fact, channel: channel,
      pavlov_options: { no_current_user: true }).call
  end
end
