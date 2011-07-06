require 'redis'
require 'redis/objects'
Redis::Objects.redis = Redis.new

#TODO renamen naar FactRelation

class Factlink < Fact
  include Redis::Objects
  
  value :evidence_fact
  value :fact
  value :type
  
  def Factlink.get_or_create(evidenceA,type,fact,user)
    if $redis.exists(Factlink.redis_key(evidenceA,type,fact))
      id = $redis.get(Factlink.redis_key(evidenceA,type,fact))
      fl = Factlink.find(id)
    else
      fl = Factlink.new
      fl.evidence_fact.value = evidenceA.id.to_s
      fl.fact.value = fact.id.to_s
      fl.type.value = type
      fl.set_added_to_factlink(user)
      fl.save
    end

    fl
  end
  
  def set_data(evidence,type,fact)
      
  end
  
  def Factlink.redis_key(evidence,type,fact)
    "factlink:#{evidence.id}:#{type}:#{fact}"
  end
  
  def get_type_opinion
    case self.type.value
    when :supports
      Opinion.for_type(:beliefs)
    when :weakening
      Opinion.for_type(:disbeliefs)
    end
  end
  
  def get_evidence_fact
    Fact.find(evidence_fact.value)
  end
  
  def get_influencing_opinion
    get_type_opinion.dfa(self.get_evidence_fact.get_opinion,self.get_opinion)
  end

end