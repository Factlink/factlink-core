class RemoveFavouritedTopics < Mongoid::Migration
  def self.up
    Redis.current.keys('user:favourited_topics:*').each do |key|
      Redis.current.del key
    end
  end

  def self.down
  end
end
