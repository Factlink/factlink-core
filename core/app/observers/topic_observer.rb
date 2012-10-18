class TopicObserver < Mongoid::Observer

  def after_create topic
    Commands::ElasticSearchIndexTopicForTextSearch.new(topic).execute
  end

  def after_update topic
    if topic.changed? and not (topic.changed & ['title', 'slug_title']).empty?
      Commands::ElasticSearchIndexTopicForTextSearch.new(topic).execute
    end
  end

  def after_destroy topic
    Commands::ElasticSearchDeleteTopicForTextSearch.new(topic).execute
  end

end
