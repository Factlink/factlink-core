class FactRelationsToComments < Mongoid::Migration
  def self.up
    FactRelation.all.ids.each do |fact_relation_id|
      Resque.enqueue MigrateFactRelationToCommentWorker, fact_relation_id
    end
  end

  def self.down
  end
end
