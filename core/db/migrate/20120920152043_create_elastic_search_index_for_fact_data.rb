class CreateElasticSearchIndexForFactData < Mongoid::Migration
  def self.up
    say_with_time "Preparing to index ElasticSearch for all FactData" do
      FactData.all.each do |fact_data|
        Resque.enqueue(CreateSearchIndexForFactData, fact_data.id)
      end
    end
  end

  def self.down
  end
end
