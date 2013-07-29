class RemoveFactRelationCredibility < Mongoid::Migration
  def self.up
    # Takes just a couple of seconds on production
    FactRelation.all.ids.each do |id|
      fact_relation = FactRelation[id]
      keys = Authority.all_on(fact_relation).map(&:key)
      Redis.current.del "", *keys
    end
  end

  def self.down
  end
end
