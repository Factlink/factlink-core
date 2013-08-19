class ReindexEverythingAgain < Mongoid::Migration
  def self.up
    Interactors::FullTextSearch::Reindex.new.call
  end

  def self.down
  end
end
