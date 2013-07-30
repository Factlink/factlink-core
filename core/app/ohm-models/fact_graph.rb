class FactGraph
  def self.recalculate
    new.recalculate
  end

  def recalculate
    calculate_user_opinions
    calculate_graph
    calculate_authority
  end

  def calculate_authority
    Authority.run_calculation(authority_calculators)
  end

  def calculate_fact_when_user_opinion_changed(fact)
    user_opinion = calculated_user_opinion(fact, fact)
    store :Fact, fact.id, :user_opinion, user_opinion
  end

  def calculate_fact_relation_when_user_opinion_changed(fact_relation)
    user_opinion = calculated_user_opinion(fact_relation, fact_relation.fact)
    store :FactRelation, fact_relation.id, :user_opinion, user_opinion
  end

  def user_opinion_for_fact(fact)
    retrieve :Fact, fact.id, :user_opinion
  end

  def user_opinion_for_fact_relation(fact_relation)
    retrieve :FactRelation, fact_relation.id, :user_opinion
  end

  def opinion_for_fact(fact)
    user_opinion = retrieve :Fact, fact.id, :user_opinion
    evidence_opinion = retrieve :Fact, fact.id, :evidence_opinion

    user_opinion + evidence_opinion
  end

  private

  def calculate_user_opinions
    Fact.all.ids.each do |id|
      calculate_user_opinions_for Fact[id]
    end
  end

  def calculate_user_opinions_for(fact)
    store :Fact, fact.id, :user_opinion, calculated_user_opinion(fact, fact)

    fact.fact_relations.each do |fact_relation|
      store :FactRelation, fact_relation.id, :user_opinion, calculated_user_opinion(fact_relation, fact)
    end

    Comment.where(fact_data_id: fact.data_id).each do |comment|
      store :Comment, comment.id, :user_opinion, calculated_user_opinion(comment, fact)
    end
  end

  def calculate_graph
    5.times do |i|
      Fact.all.ids.each do |id|
        store :Fact, id, :evidence_opinion, calculated_evidence_opinion(Fact[id])
      end
    end
  end

  def calculated_evidence_opinion(fact)
    influencing_opinions = fact.fact_relations.all.map do |fact_relation|
      influencing_opinion_for_fact_relation(fact_relation)
    end

    influencing_opinions += Comment.where(fact_data_id: fact.data_id).map do |comment|
      influencing_opinion_for_comment(comment, fact)
    end

    DeadOpinion.combine(influencing_opinions)
  end

  def influencing_opinion_for_fact_relation(fact_relation)
    from_fact_opinion = opinion_for_fact(fact_relation.from_fact)
    user_opinion      = retrieve :FactRelation, fact_relation.id, :user_opinion
    evidence_type     = OpinionType.for_relation_type(fact_relation.type)

    calculated_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)
  end

  def influencing_opinion_for_comment(comment, fact)
    user_opinion = retrieve :Comment, comment.id, :user_opinion
    evidence_type = OpinionType.real_for(comment.type)

    calculated_influencing_opinion(intrinsic_opinion_for_comment(comment, fact), user_opinion, evidence_type)
  end

  def intrinsic_opinion_for_comment(comment, fact)
    creator_authority = Authority.on(fact, for: comment.created_by).to_f + 1.0

    DeadOpinion.for_type(:believes, authority_of_comment_based_on_creator_authority(creator_authority))
  end

  COMMENT_AUTHORITY_MULTIPLIER = 10

  def authority_of_comment_based_on_creator_authority(creator_authority)
    creator_authority * COMMENT_AUTHORITY_MULTIPLIER
  end

  def calculated_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)
    net_fact_authority      = from_fact_opinion.net_authority
    net_relevance_authority = user_opinion.net_authority

    authority = [[net_fact_authority, net_relevance_authority].min, 0].max

    DeadOpinion.for_type(evidence_type, authority)
  end

  def calculated_user_opinion(thing_with_believable, fact)
    UserOpinionCalculation.new(thing_with_believable.believable) do |user|
      Authority.on(fact, for: user).to_f + 1.0
    end.opinion
  end

  def opinion_store
    Opinion::Store.new HashStore::Redis.new('FactGraphOpinion')
  end

  delegate :store, :retrieve, to: :opinion_store

  def authority_calculators
    [
      MapReduce::FactAuthority,
      MapReduce::ChannelAuthority,
      MapReduce::TopicAuthority,
      MapReduce::FactCredibility
    ]
  end
end
