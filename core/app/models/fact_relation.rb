class FactRelation < Fact
  reference :from_fact, Fact
  reference :fact, Fact
  
  attribute :type
  
  #TODO add proper index for get_or_create
  
  def FactRelation.get_or_create(evidenceA, type, fact, user)
    # Type => :supporting || :weakening
    if $redis.exists(FactRelation.redis_key(evidenceA, type, fact))
      id = $redis.get(FactRelation.redis_key(evidenceA, type, fact))
      fl = FactRelation[id]
    else
      fl = FactRelation.create(:data => FactData.new())
      fl.from_fact = evidenceA
      fl.fact = fact
      fl.type = type
      #TODO enable this again:
      #fl.created_by = user
      
      fl.set_added_to_factlink(user)
      fl.save
      $redis.set(FactRelation.redis_key(evidenceA,type,fact),fl.id)
    end

    return fl
  end
  
  def set_data(evidence, type, fact)
    
  end
  
  def percentage
    (100 * self.get_influencing_opinion.weight / (self.get_to_fact.get_opinion.weight + 0.00001)).to_i
  end
  
  def FactRelation.redis_key(evidence, type, fact)
    "factlink:#{evidence.id}:#{type}:#{fact}"
  end
  
  def get_type_opinion    
    case self.type.value
    when "supporting"
      Opinion.for_type(:beliefs)
    when "weakening"
      Opinion.for_type(:disbeliefs)
    end
  end
  
  def get_from_fact
    Fact[from_fact.value]
  end
  
  def get_to_fact
    Fact[fact.value]
  end
  
  def get_influencing_opinion
    # redis_key = 'loop_detection_fact_relation'
    # 
    # unless $redis.sismember(redis_key, self.id)
    #   
    #   $redis.sadd(redis_key, self.id)
    #   return get_type_opinion.dfa(self.get_from_fact.get_opinion, self.get_opinion)
    # 
    # else
    #   # p "Loop detected - #{self.id}"
    #   $redis.del(redis_key)
    #   return Opinion.new(0, 0, 0)
    # end
    
    get_type_opinion.dfa(self.get_from_fact.get_opinion, self.get_opinion)
  end
end