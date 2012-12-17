class CreateSearchIndexForTopics

  @queue = :search_index_operations

  def self.perform(topic_id)
    topic = Topic.find(topic_id)

    if topic
      Commands::ElasticSearchIndexTopicForTextSearch.new(topic).execute
    else
      raise "Failed adding index for topic with topic_id: #{topic_id}"
    end
  end

end
