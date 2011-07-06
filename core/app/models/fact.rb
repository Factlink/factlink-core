class Fact < BaseFact

  def add_evidence(type,factlink,user)
    factlink = Factlink.get_or_create(factlink,type,self)
    factlink.set_added_to_factlink(self, user)
    $redis.sadd(redis_key(type), factlink.id)
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

  def evidence_opinion
    opinions = []
    [:supporting, :weakening].each do |type|
      factlinks = Factlink.where(:_id.in => $redis.zrange(self.redis_key(type), 0, -1))
      factlinks.each do |factlink|
        opinions << factlink.get_influencing_opinion
      end
    end    
    Opinion.combine(opinions)
  end

  def get_opinion
    user_opinion = super.get_opinion
    user_opinion + evidence_opinion
  end

end
