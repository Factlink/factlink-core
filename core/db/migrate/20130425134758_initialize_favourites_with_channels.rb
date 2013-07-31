class InitializeFavouritesWithChannels < Mongoid::Migration
  def self.up
    Channel.all.each do |ch|
      if ch.type == 'channel'
        graph_user_id = ch.created_by_id.to_s
        topic_id = ch.topic.id.to_s
        Pavlov.old_command 'topics/favourite', graph_user_id, topic_id
      end
    end
  end

  def self.down
  end
end
