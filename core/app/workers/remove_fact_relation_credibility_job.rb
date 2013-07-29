class RemoveFactRelationCredibility
  def self.perform
    FactRelation.all.ids.each do |id|
      fact_relation = FactRelation[id]
      keys = Authority.all_on(fact_relation).map(&:key)
      Redis.current.del "", *keys
    end
  end
end
