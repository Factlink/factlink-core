require_relative '../../app/interactors/interactors/full_text_search/reindex.rb'

class ReindexFactDataTopicAndUser < Mongoid::Migration
  def self.up
    Interactors::FullTextSearch::Reindex.new.call
  end

  def self.down
  end
end
