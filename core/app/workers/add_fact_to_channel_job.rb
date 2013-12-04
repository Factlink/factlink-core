# TODO: extract out interactor, containing both this, and also
#       some methods which are always called together with this
class AddFactToChannelJob
  include Pavlov::Helpers

  def self.perform(fact_id, channel_id)
    fact    = Fact[fact_id]
    channel = Channel[channel_id]

    return unless fact and channel

    fact.channels.add channel

    Pavlov.command :"topics/add_fact",
      fact_id: fact.id,
      topic_slug_title: channel.slug_title,
      score: ''
  end
end
