class AddAllContainingFactlinksToTopic
  @queue = :channel_operations

  def initialize(topic_id)
    @topic = Topic.find topic_id
  end

  def perform
    redis_key.zunionstore sorted_cached_facts_keys, aggregate: 'min'
  end

  def redis_key
    Topic.redis[slug_title][:facts]
  end

  def slug_title
    @topic.slug_title
  end

  def channels
    @topic.channels
  end

  def sorted_cached_facts_keys
    channels.map do |channel|
      channel.sorted_cached_facts.key
    end
  end

  def self.perform(topic_id)
    new(topic_id).perform
  end
end