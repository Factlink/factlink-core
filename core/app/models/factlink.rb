class Factlink < Fact
  
  def Factlink.get_or_create(evidence,type,fact)
    if $redis.exists(Factlink.redis_key(evidence,type,fact), factlink.id.to_s)
      id = $redis.exists(Factlink.redis_key(evidence,type,fact), factlink.id.to_s)
      Factlink.get(:id = id)
    else
      Factlink.new(evidence,type,fact)
    end
  end
  
  def Factlink.redis_key(evidence,type,fact)
    "factlink:#{evidence.id}:#{type}:#{fact}"
  end
  
end