
class Opinion
  class Store
    def initialize(store=NestedHashHashStore.new)
      @store = store
    end

    def store object_type, object_id, opinion_type, opinion
      @store[object_type,object_id,opinion_type] = opinion.to_hash
    end

    def retrieve object_type, object_id, opinion_type
      retrieved = @store[object_type,object_id,opinion_type]
      if retrieved.value?
        DeadOpinion.from_hash retrieved.get
      else
        DeadOpinion.zero
      end
    end
  end
end
