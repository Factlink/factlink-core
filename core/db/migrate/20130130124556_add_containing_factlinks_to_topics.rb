class AddContainingFactlinksToTopics < Mongoid::Migration
  def self.up
    Topic.all.each do |topic|
      Resque.enqueue(AddAllContainingFactlinksToTopic, topic.id)
    end
  end

  def self.down
    Topic.all.each do |topic|
      Topic.redis[topic.slug_title][:facts].del
    end
  end
end
