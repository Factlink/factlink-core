class CreateElasticSearchIndexForTopics < Mongoid::Migration
  def self.up
    say_with_time "Preparing to index ElasticSearch for all Topics" do
      Topic.all.each do |topic|
        Resque.enqueue(CreateSearchIndexForTopics, topic.id)
      end
    end
  end

  def self.down
  end
end
