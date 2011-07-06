class Factlink < Fact
  
  def Factlink.get_or_create(evidence,type,fact)
    if $redis.exists(Factlink.redis_key(evidence,type,fact), factlink.id.to_s)
      id = $redis.exists(Factlink.redis_key(evidence,type,fact), factlink.id.to_s)
      Factlink.find(id)
    else
      Factlink.new(evidence,type,fact)
    end
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