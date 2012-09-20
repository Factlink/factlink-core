class TopicObserver < Mongoid::Observer

  def after_create topic
    IndexTopicForTextSearch.new(topic).execute
  end

  def after_update topic
    if topic.changed? and not (topic.changed & ['title', 'slug_title']).empty?
      IndexTopicForTextSearch.new(topic).execute
    end
  end

  def after_destroy topic
    DeleteTopicForTextSearch.new(topic).execute
  end

end
