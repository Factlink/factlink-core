# TODO: extract out interactor, containing both this, and also
#       some methods which are always called together with this
class AddFactToChannelJob
  include Pavlov::Helpers

  def self.perform(fact_id, channel_id, options={})
    fact    = Fact[fact_id]
    channel = Channel[channel_id]
    score   = options['score']

    return unless fact and channel

    Pavlov.interactor(:'channels/add_fact_without_propagation',
                      fact: fact, channel: channel,
                      score: score)
  end
end
