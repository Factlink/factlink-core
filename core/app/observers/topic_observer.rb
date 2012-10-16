class TopicObserver < Mongoid::Observer

  def after_create topic
    ElasticSearchIndexTopicForTextSearch.new(topic).execute
  end

  def after_update topic
    if topic.changed? and not (topic.changed & ['title', 'slug_title']).empty?
      ElasticSearchIndexTopicForTextSearch.new(topic).execute
    end
  end

  def after_destroy topic
    ElasticSearchDeleteTopicForTextSearch.new(topic).execute
  end

end
