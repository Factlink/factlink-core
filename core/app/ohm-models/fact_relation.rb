class FactRelation < Basefact
  
  reference :from_fact, Fact
  reference :fact, Fact

  attribute :type # => :supporting || :weakening

  def validate
    assert_present :from_fact_id
    assert_present :fact_id
    assert_present :type # TODO check if it's one of the permitted values
  end

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
    fl = FactRelation.create(
      :created_by => user.graph_user,
      :from_fact => from,
      :fact => to,
      :type => type
    )

    #TODO this should use a collection
    to.evidence(type) << fl

    $redis.set(FactRelation.redis_key(from,type,to), fl.id)
    fl
  end

  def FactRelation.redis_key(evidence, type, fact)
    "factlink:#{evidence.id}:#{type}:#{fact.id}"
  end


  def percentage
    if self.get_to_fact.get_opinion.weight == 0
      return 0
    else
      return (100 * self.get_influencing_opinion.weight / (self.get_to_fact.get_opinion.weight)).round.to_i
    end
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

  deprecate
  def get_to_fact
    fact
  end

  def delete
    $redis.del(FactRelation.redis_key(from_fact, self.type, fact))
    fact.evidence(self.type.to_sym).delete(self)
    super
  end


  reference :influencing_opinion, Opinion
  
  def calculate_influencing_opinion(depth=0)
    self.influencing_opinion = get_type_opinion.dfa(self.from_fact.get_opinion(depth), self.get_user_opinion(depth)).save
    save
  end
  
  def get_influencing_opinion(depth=0)
    if depth > 0
      calculate_influencing_opinion(depth)
    end
    self.influencing_opinion || Opinion.identity
  end
  
  def get_opinion(depth=0)
    self.get_user_opinion(depth) || Opinion.identity
  end
  
end