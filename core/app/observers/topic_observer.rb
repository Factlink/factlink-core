class TopicObserver < Mongoid::Observer
  include Pavlov::Helpers

  def after_create topic
    command :'text_search/index_topic',
                topic: topic
  end

  def after_update topic
    return unless topic.changed?

    command :'text_search/index_topic',
                topic: topic,
                changed: topic.changed
  end

  def after_destroy topic
    old_command :elastic_search_delete_topic_for_text_search, topic
  end

end
