class TopicObserver < Mongoid::Observer
  include Pavlov::Helpers

  def after_create topic
    old_command :'text_search/index_topic', topic
  end

  def after_update topic
    if topic.changed? and not (topic.changed & ['title', 'slug_title']).empty?
      old_command :'text_search/index_topic', topic
    end
  end

  def after_destroy topic
    old_command :elastic_search_delete_topic_for_text_search, topic
  end

end
