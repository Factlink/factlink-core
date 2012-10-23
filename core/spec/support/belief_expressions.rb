module BeliefExpressions
  def b(user,fact)
    something_happened
    fact.add_opinion(:believes,user.graph_user)
  end

  def d(user,fact)
    something_happened
    fact.add_opinion(:disbelieves,user.graph_user)
  end

  def u(user,fact)
    something_happened
    fact.add_opinion(:doubts,user.graph_user)
  end

  def _(b,d,u,a)
    Opinion.new(b:b,d:d,u:u,a:a)
  end

  def god_user
    @god_user ||= GraphUser.create
  end

  def global_channel
    @t  ||= Topic.create title: 'global'
    @ch ||= Channel.create title: 'global', created_by: god_user
  end

  def add_to_global_channel(f)
    global_channel.add_fact f
  end

  def possible_reset
    unless @nothing_happened
      reset
    end
  end

  def reset
    Fact.all.each do |f|
      add_to_global_channel(f)
    end
    @random_fact ||= Fact.create(created_by: god_user)
    add_to_global_channel @random_fact
    FactGraph.reset_values
    FactGraph.recalculate
    @nothing_happened = true
  end

  def something_happened
    @nothing_happened = false
  end

  def a(user)
    reset
    (Authority.on(@random_fact, for: GraphUser[user.graph_user.id]).to_f+1).should
  end

  def opinion?(fact)
    possible_reset
    # values are recalculated in Redis, so get the object fresh from Redis
    fact = fact.class[fact.id]
    fact.get_opinion.should
  end
end
