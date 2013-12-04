class RemoveTopicTopUsers < Mongoid::Migration
  def self.up
    Topic.all.each do |topic|
      topic.redis[topic.id][:top_users].del
    end
  end

  def self.down
  end
end
