autoload :Basefact, 'basefact'
autoload :Fact, 'fact'
autoload :FactRelation, 'fact_relation'
autoload :GraphUser, 'graph_user'
autoload :OurOhm, 'our_ohm'
autoload :Site, 'site'

autoload :Opinion, 'opinion'
autoload :Opinionable, 'opinionable'



class FactRelation < Basefact
  reference :from_fact, Fact
  reference :fact, Fact

  attribute :type # => :supporting || :weakening

  #TODO add proper index for get_or_create
  def FactRelation.get_or_create(from, type, to, user)
    if FactRelation.exists_already?(from,type,to)
      FactRelation.get_relation(from,type,to)
    else
      FactRelation.create_new(from,type,to, user)
    end
  end

  def FactRelation.exists_already?(from,type,to)
    $redis.exists(FactRelation.redis_key(from, type, to))
  end

  def FactRelation.get_relation(from,type,to)
    id = $redis.get(FactRelation.redis_key(from, type, to))
    FactRelation[id]
  end

  def FactRelation.create_new(from,type,to,user)
    fl = FactRelation.create
    fl.from_fact = from
    fl.fact = to
    fl.type = type
    #TODO enable this again:
    fl.created_by = user

    to.evidence(type) << fl

    fl.save
    $redis.set(FactRelation.redis_key(from,type,to), fl.id)
    fl
  end

  def FactRelation.redis_key(evidence, type, fact)
    "factlink:#{evidence.id}:#{type}:#{fact.id}"
  end


  def percentage
    (100 * self.get_influencing_opinion.weight / (self.get_to_fact.get_opinion.weight + 0.00001)).to_i
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
    $redis.del(FactRelation.redis_key(from_fact, self.type, fact))
    fact.evidence(self.type.to_sym).delete(self)
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
    get_type_opinion.dfa(self.from_fact.get_opinion, self.get_opinion)
  end
end