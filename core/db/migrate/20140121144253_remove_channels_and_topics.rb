class RemoveChannelsAndTopics < Mongoid::Migration
  def self.up
    mongoid = Mongoid::Sessions.default
    mongoid[:topics].drop()

    old_topic_keys = Ohm.redis.keys('Topic:*')
    Redis.current.del *old_topic_keys unless old_topic_keys.empty?

    old_new_topic_keys = Ohm.redis.keys('new_topic:*')
    Redis.current.del *old_new_topic_keys unless old_new_topic_keys.empty?
  end

  def self.down
  end
end
