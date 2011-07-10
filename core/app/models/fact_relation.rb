require 'redis'
require 'redis/objects'
Redis::Objects.redis = Redis.new

class FactRelation < Fact
  include Redis::Objects
  
  value :from_fact
  value :fact
  value :type
  
  def FactRelation.get_or_create(evidenceA, type, fact, user)
    # Type => :supporting || :weakening
    if $redis.exists(FactRelation.redis_key(evidenceA, type, fact))
      id = $redis.get(FactRelation.redis_key(evidenceA, type, fact))
      fl = FactRelation.find(id)
    else
      fl = FactRelation.new
      fl.from_fact.value = evidenceA.id.to_s
      fl.fact.value = fact.id.to_s
      fl.type.value = type
      fl.created_by = user
      
      fl.set_added_to_factlink(user)
      fl.save
    end

    fl
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
    Fact.find(from_fact.value)
  end
  
  def get_to_fact
    Fact.find(fact.value)
  end
  
  def get_influencing_opinion    
    get_type_opinion.dfa(self.get_from_fact.get_opinion, self.get_opinion)
  end


end