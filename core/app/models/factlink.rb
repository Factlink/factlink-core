require 'redis'
require 'redis/objects'
Redis::Objects.redis = Redis.new

#TODO renamen naar FactRelation
class Factlink < Fact
  include Redis::Objects
  
  value :evidence
  value :fact
  value :type
  
  def Factlink.get_or_create(evidence,type,fact)
    if $redis.exists(Factlink.redis_key(evidence,type,fact))
      id = $redis.get(Factlink.redis_key(evidence,type,fact))
      Factlink.find(id)
    else
      fl = Factlink.new
      fl.evidence.value = evidence
      fl.fact.value = fact
      fl.type.value = type
    end
  end
  
  def set_data(evidence,type,fact)
      
  end
  
  def Factlink.redis_key(evidence,type,fact)
    "factlink:#{evidence.id}:#{type}:#{fact}"
  end
  
  def get_type_opinion
    case @type
    when :supports
      Opinion.for_type(:beliefs)
    when :weakening
      Opinion.for_type(:disbeliefs)
    end
  end
  
  def get_influencing_opinion
    get_type_opinion.dfa(self.evidence.get_opinion,self.get_opinion)
  end
  

end