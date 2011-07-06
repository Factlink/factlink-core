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
      Opinion.new(1,0,0,1)
    when :weakening
      Opinion.new(0,0,1,1)
    end
  end
  
  def get_influencing_opinion
    get_type_opinion.dfa(self.evidence.get_opinion,self.get_opinion)
  end
  
end