class Fact < BaseFact

  def add_evidence(type,factlink,user)
    factlink = Factlink.get_or_create(factlink,type,self)
    factlink.set_added_to_factlink(self, user)
    $redis.sadd(redis_key(type), factlink.id)
  end
  
  def remove_evidence(type,factlink,user)
  end
  

  def evidence_ids(type)
    $redis.smembers(redis_key(type))
  end
  
  def supported_by?(factlink)
    $redis.sismember(redis_key(:supporting), factlink.id.to_s)
  end

  def weakened_by?(factlink)
    $redis.sismember(redis_key(:weakening), factlink.id.to_s)
  end

  # Used for sorting
  def self.column_names
    self.fields.collect { |field| field[0] }
  end


  def total_opinion
    #onzincode, maar doet wat ik wil
    #a = Opinion.combine_opinions(self.opiniated.map{ |x| x.opinion_on(self)})
    #b = Opinion.combine_opinions(self.supporting_facts.to_opinions)
    #return a + b
  end

  def get_opinion
    Opinion.new(1,0,0,0.5)
  end

end
