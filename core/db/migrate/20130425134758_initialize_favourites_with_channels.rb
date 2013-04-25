class InitializeFavouritesWithChannels < Mongoid::Migration
  include Pavlov::Helpers

  def self.up
    Channel.all.each do |ch|
      if ch.type == 'channel'
        graph_user_id = ch.created_by_id
        topic_id = ch.topic.id
        command 'topics/favourite', graph_user_id, topic_id
      end
    end
  end

  def self.down
  end
end
