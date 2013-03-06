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
    return unless can_perform and should_perform

    to_be_extracted_add_command

    propagate_to_channels
  end

  def to_be_extracted_add_command
    interactor :"channels/add_fact_without_propagation", fact, channel, score
    command :"topics/add_fact", fact.id, channel.slug_title, score.to_s
    unless posted_by_channel_owner?
      unless fact_created_by_channel_owner?
        channel.unread_facts.add(fact)
      end
    end
  end

  def can_perform
    fact and channel
  end

  def should_perform
    not(already_propagated or already_deleted)
  end

  def score
    @options['score']
  end

  def initiated_by_id
    @options['initiated_by_id']
  end

  def already_propagated
    channel.sorted_cached_facts.include?(fact)
  end

  def already_deleted
    channel.sorted_delete_facts.include?(fact)
  end

  def channel_facts
    ChannelFacts.new(channel)
  end

  def posted_by_channel_owner?
    channel.created_by_id == initiated_by_id
  end

  def fact_created_by_channel_owner?
    channel.created_by_id == fact.created_by_id
  end

  def propagate_to_channels
    return unless should_propagate?

    channel.containing_channels.ids.each do |ch_id|
      Resque.enqueue(AddFactToChannelJob, fact.id, ch_id, @options)
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
