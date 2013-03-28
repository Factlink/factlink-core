# TODO: extract out interactor, containing both this, and also
#       some methods which are always called together with this

class AddChannelToChannel
  include Pavlov::Helpers
  NUMBER_OF_INITIAL_FACTS = 10

  @queue = :channel_operations

  attr_reader :subchannel, :channel

  def initialize(subchannel, channel)
    @subchannel = subchannel
    @channel = channel
  end

  def perform
    latest_facts.each do |fact|
      interactor :"channels/add_fact_without_propagation", fact, channel, nil, true
    end
  end

  def latest_facts
    subchannel.sorted_internal_facts.below('inf', count: NUMBER_OF_INITIAL_FACTS)
  end

  def self.perform(subchannel, channel)
    new(subchannel, channel).perform
  end
end
