# TODO: extract out interactor, containing both this, and also
#       some methods which are always called together with this

class AddFactToChannelJob
  include Pavlov::Helpers

  @queue = :channel_operations

  attr_reader :fact, :channel

  def initialize(fact_id, channel_id, options={})
    @fact ||= Fact[fact_id]
    @channel ||= Channel[channel_id]
    @options = options
  end

  def perform
    return unless fact and channel

    executed = interactor :"channels/add_fact_without_propagation", fact, channel, score, not(channel.created_by_id == initiated_by_id)

    propagate_to_channels if executed
  end

  def score
    @options['score']
  end

  def initiated_by_id
    @options['initiated_by_id']
  end

  def propagate_to_channels
    return unless should_propagate?

    channel.containing_channels.ids.each do |ch_id|
      if ch = Channel[ch_id]
        interactor :"channels/add_fact_without_propagation", fact, ch, score, true
      end
    end
  end

  # only propagate if the fact was added to this channel
  def should_propagate?
    channel.sorted_internal_facts.include? fact
  end

  def self.perform(fact_id, channel_id, options={})
    new(fact_id, channel_id, options).perform
  end
end
