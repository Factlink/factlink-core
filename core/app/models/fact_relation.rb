class FactRelation < Basefact
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
      fl = FactRelation.create
      fl.from_fact = evidenceA
      fl.fact = fact
      fl.type = type
      #TODO enable this again:
      fl.created_by = user
      
      fl.save
      $redis.set(FactRelation.redis_key(evidenceA,type,fact), fl.id)
    end

    return fl
  end
  
  def percentage
    (100 * self.get_influencing_opinion.weight / (self.get_to_fact.get_opinion.weight + 0.00001)).to_i
  end
  
  def FactRelation.redis_key(evidence, type, fact)
    "factlink:#{evidence.id}:#{type}:#{fact}"
  end
  
  def get_type_opinion
    
    # Just to be sure: parse to Symbol
    case self.type.to_sym
    when :supporting
      Opinion.for_type(:beliefs)
    when :weakening
      Opinion.for_type(:disbeliefs)
    end

  end
  
  deprecate
  def get_from_fact
    from_fact
  end
  
  def get_to_fact
  deprecate
    fact
  end

  def delete
    super
  end
  
  def get_influencing_opinion
    # Primitive loop detection; not working correct
    # key = "loop_detection_2"
    # 
    # if $redis.sismember(key, self.id)
    #   $redis.del(key)      
    #   return Opinion.new(0, 0, 0)
    # else
    #   $redis.sadd(key, self.id)      
    #   return get_type_opinion.dfa(self.get_from_fact.get_opinion, self.get_opinion)
    # end

    # This is the only thing to return when the loop detection is not used:
    get_type_opinion.dfa(self.get_from_fact.get_opinion, self.get_opinion)
  end
end