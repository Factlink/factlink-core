# TODO: extract out interactor, containing both this, and also
#       some methods which are always called together with this

# README:
# This classed should be called when doing a repost. It will propagate
# to its direct followers.
#
# It is assumed that this action is performed by the owner of the
# channel and therefore the unread bit should never be set for the
# direct add
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

    executed = old_interactor :"channels/add_fact_without_propagation", fact, channel, score, false

    propagate_to_channels if executed
  end

  def score
    @options['score']
  end

  def initiated_by_id
    @options['initiated_by_id']
  end

  def propagate_to_channels
    channel.containing_channels.ids.each do |ch_id|
      if ch = Channel[ch_id]
        old_interactor :"channels/add_fact_without_propagation", fact, ch, score, true
      end
    end
  end

  def self.perform(fact_id, channel_id, options={})
    new(fact_id, channel_id, options).perform
  end
end
