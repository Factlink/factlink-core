module BeliefExpressions
  def b(user,fact)
    fact.add_opinion(:beliefs,user)
  end

  def d(user,fact)
    fact.add_opinion(:disbeliefs,user)
  end

  def u(user,fact)
    fact.add_opinion(:doubts,user)
  end

  def _(b,d,u,a)
    Opinion.new(:b=>b,:d=>d,:u=>u,:a=>a)
  end

  def a(user)
    user.authority.should
  end

  def opinion?(fact)
    FactGraph.reset_values
    FactGraph.recalculate
    # values are recalculated in Redis, so get the object fresh from Redis
    fact = fact.class[fact.id]
    fact.get_opinion.should
  end
end