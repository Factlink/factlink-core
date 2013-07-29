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

  def _(believes, disbelieves, doubts, authority)
    DeadOpinion.new(believes, disbelieves, doubts, authority)
  end

  alias :believes :b
  alias :disbelieves :d
  alias :doubts :u

  def god_user
    @god_user ||= GraphUser.create
  end

  def global_channel
    @t  ||= Topic.create title: 'global'
    @ch ||= Channel.create title: 'global', created_by: god_user
  end

  def add_to_global_channel(factlink)
    Interactors::Channels::AddFact.new(factlink, global_channel, no_current_user:true).call
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

  def opinion?(base_fact)
    possible_reset
    case base_fact
    when Fact
      opinion = Pavlov.query 'opinions/opinion_for_fact', base_fact
    when FactRelation
      opinion = FactGraph.new.user_opinion_for_fact_relation base_fact
    else
      raise 'Unknown base_fact class'
    end
    opinion.should
  end
end
