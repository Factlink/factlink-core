class ReindexSearch < Mongoid::Migration
  def self.up

    say_with_time "Queueing reindex ElasticSearch for all Users, FactData and Topics" do

      User.all.each do |user|
        Resque.enqueue(CreateSearchIndexForUser, user.id)
      end

      FactData.all.each do |fact_data|
        Resque.enqueue(CreateSearchIndexForFactData, fact_data.id)
      end

      Topic.all.each do |topic|
        Resque.enqueue(CreateSearchIndexForTopics, topic.id)
      end
    end

  end

  def self.down
  end
end
