class RemoveFactRelationCredibilityJob

  @queue = :fact_relation_operations

  def self.perform
    FactRelation.all.ids.each do |id|
      fact_relation = FactRelation[id]
      keys = Authority.all_on(fact_relation).map(&:key)
      Redis.current.del "", *keys
    end

    Redis.current.del "", *Redis.current.keys("Authority+NEW+LIST+on+FactRelation+*")
  end
end
