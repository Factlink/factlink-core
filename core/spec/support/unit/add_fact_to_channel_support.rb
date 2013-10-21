module AddFactToChannelSupport
  def add_fact_to_channel fact, channel
    Pavlov.interactor :'channels/add_fact',
                      fact: fact, channel: channel,
                      pavlov_options: { no_current_user: true }
  end
end
