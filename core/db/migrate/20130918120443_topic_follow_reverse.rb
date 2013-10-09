class TopicFollowReverse < Mongoid::Migration
  def self.up
    GraphUser.all.ids.each do |graph_user_id|
      user_favourited_topics = UserFavouritedTopics.new(graph_user_id)
      topic_ids = user_favourited_topics.topic_ids

      topic_ids.each do |topic_id|
        user_favourited_topics.favourite topic_id
      end
    end
  end

  def self.down
  end
end
