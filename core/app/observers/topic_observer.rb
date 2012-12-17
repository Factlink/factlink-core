class TopicObserver < Mongoid::Observer
  include Pavlov::Helpers

  def after_create topic
    command :elastic_search_index_topic_for_text_search, topic
  end

  def after_update topic
    if topic.changed? and not (topic.changed & ['title', 'slug_title']).empty?
      command :elastic_search_index_topic_for_text_search, topic
    end
  end

  def after_destroy topic
    command :elastic_search_delete_topic_for_text_search, topic
  end

end
