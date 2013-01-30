class AddContainingFactlinksToTopics < Mongoid::Migration
  def self.up
    Topic.all.each do |topic|
      Resque.enqueue(AddAllContainingFactlinksToTopic, topic.id)
    end
  end

  def self.down
  end
end