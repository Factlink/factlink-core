class ReindexElasticsearchAfterRemovingTopics < Mongoid::Migration
  def self.up
    Pavlov.interactor :'full_text_search/reindex'
  end

  def self.down
  end
end
