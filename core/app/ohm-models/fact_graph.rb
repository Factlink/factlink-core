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
    store :Fact, fact.id, :user_opinion, calculated_user_opinion_for_base_fact(fact)
  end

  def calculate_fact_relation_when_user_opinion_changed(fact_relation)
    store :FactRelation, fact_relation.id, :user_opinion, calculated_user_opinion_for_base_fact(fact_relation)
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
      store :Fact, id, :user_opinion, calculated_user_opinion_for_base_fact(Fact[id])
    end

    FactRelation.all.ids.each do |id|
      store :FactRelation, id, :user_opinion, calculated_user_opinion_for_base_fact(FactRelation[id])
    end

    Comment.all.each do |comment|
      store :Comment, comment.id.to_s, :user_opinion, calculated_user_opinion_for_comment(comment)
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

    influencing_opinions += Comment.where({fact_data_id: fact.data_id}).map do |comment|
      influencing_opinion_for_comment(comment)
    end

    DeadOpinion.combine(influencing_opinions)
  end

  def influencing_opinion_for_fact_relation(fact_relation)
    from_fact_opinion = opinion_for_fact(fact_relation.from_fact)
    user_opinion      = retrieve :FactRelation, fact_relation.id, :user_opinion
    evidence_type     = OpinionType.for_relation_type(fact_relation.type)

    calculated_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)
  end

  def influencing_opinion_for_comment(comment)
    user_opinion = retrieve :Comment, comment.id.to_s, :user_opinion

    calculated_influencing_opinion(intrinsic_opinion_for_comment(comment), user_opinion, comment.type.to_sym)
  end

  def intrinsic_opinion_for_comment(comment)
    fact = comment.fact_data.fact
    creator_authority = Authority.on(fact, for: comment.created_by).to_f + 1.0

    DeadOpinion.new(1,0,0, authority_of_comment_based_on_creator_authority(creator_authority))
  end

  def authority_of_comment_based_on_creator_authority(creator_authority)
    10 * creator_authority
  end

  def calculated_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)
    net_fact_authority      = from_fact_opinion.net_authority
    net_relevance_authority = user_opinion.net_authority

    authority = [[net_fact_authority, net_relevance_authority].min, 0].max

    DeadOpinion.for_type(evidence_type, authority)
  end

  def calculated_user_opinion_for_base_fact(base_fact)
    UserOpinionCalculation.new(base_fact.believable) do |user|
      Authority.on(base_fact, for: user).to_f + 1.0
    end.opinion
  end

  def calculated_user_opinion_for_comment(comment)
    fact = Comment.find(comment.id).fact_data.fact

    UserOpinionCalculation.new(comment.believable) do |user|
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
      MapReduce::FactCredibility,
      MapReduce::FactRelationCredibility
    ]
  end
end
