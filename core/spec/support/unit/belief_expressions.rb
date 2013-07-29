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

  def add_supporting_comment(user, fact)
    comment = Pavlov.command :create_comment, fact.id.to_i, 'believes', 'comment', user.id.to_s
    something_happened
    comment
  end

  def add_weakening_comment(user, fact)
    comment = Pavlov.command :create_comment, fact.id.to_i, 'disbelieves', 'comment', user.id.to_s
    something_happened
    comment
  end

  def believes_comment(user, comment)
    Pavlov.command :'comments/set_opinion', comment.id.to_s, 'believes', user.graph_user
  end

  def disbelieves_comment(user, comment)
    Pavlov.command :'comments/set_opinion', comment.id.to_s, 'disbelieves', user.graph_user
  end

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

  def opinion?(fact)
    possible_reset
    opinion = Pavlov.query 'opinions/opinion_for_fact', fact
    opinion.should
  end

  def fact_relation_user_opinion?(fact_relation)
    possible_reset
    opinion = FactGraph.new.user_opinion_for_fact_relation fact_relation
    opinion.should
  end

  def comment_user_opinion?(comment)
    possible_reset
    opinion = FactGraph.new.user_opinion_for_comment comment
    opinion.should
  end
end
