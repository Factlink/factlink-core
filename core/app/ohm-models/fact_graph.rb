class FactGraph
  # Only used in tests
  def self.recalculate
    new.recalculate
  end

  def recalculate
    calculate_user_opinions
    calculate_graph
  end

  def user_opinion_for_fact(fact) # Only used in tests
    retrieve :Fact, fact.id, :user_opinion
  end

  def user_opinion_for_fact_relation(fact_relation) # Only used in tests
    retrieve :FactRelation, fact_relation.id, :user_opinion
  end

  def user_opinion_for_comment(comment) # Only used in tests
    retrieve :Comment, comment.id, :user_opinion
  end

  def opinion_for_fact(fact) # Only used in tests
    user_opinion = retrieve :Fact, fact.id, :user_opinion
    evidence_opinion = retrieve :Fact, fact.id, :evidence_opinion

    user_opinion + evidence_opinion
  end

  def impact_opinion_for_fact_relation(fact_relation, options={}) # Only used in tests
    from_fact_opinion = opinion_for_fact(fact_relation.from_fact)
    user_opinion      = retrieve :FactRelation, fact_relation.id, :user_opinion
    evidence_type     = OpinionType.for_relation_type(fact_relation.type)

    calculated_impact_opinion(from_fact_opinion, user_opinion, evidence_type, options)
  end

  def impact_opinion_for_comment(dead_comment, options={}) # Only used in tests
    comment = Comment.find(dead_comment.id)
    fact = comment.fact_data.fact
    impact_opinion_for_comment_and_fact(comment, fact, options)
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
    impact_opinions = fact.fact_relations.all.map do |fact_relation|
      impact_opinion_for_fact_relation(fact_relation)
    end

    impact_opinions += Comment.where(fact_data_id: fact.data_id).map do |comment|
      impact_opinion_for_comment_and_fact(comment, fact)
    end

    DeadOpinion.combine(impact_opinions)
  end

  def impact_opinion_for_comment_and_fact(comment, fact, options={})
    user_opinion = retrieve :Comment, comment.id, :user_opinion
    evidence_type = OpinionType.real_for(comment.type)

    calculated_impact_opinion(intrinsic_opinion_for_comment(comment, fact), user_opinion, evidence_type, options)
  end

  COMMENT_INTRINSIC_CREDIBILITY = 10

  def intrinsic_opinion_for_comment(comment, fact)
    DeadOpinion.for_type(:believes, COMMENT_INTRINSIC_CREDIBILITY)
  end

  def calculated_impact_opinion(from_fact_opinion, user_opinion, evidence_type, options={})
    net_fact_authority      = from_fact_opinion.net_authority
    net_relevance_authority = user_opinion.net_authority

    authority = [net_fact_authority, net_relevance_authority].min

    if options[:allow_negative_authority]
      DeadOpinion.for_type(evidence_type, authority)
    else
      DeadOpinion.for_type(evidence_type, authority).positive
    end
  end

  def calculated_user_opinion(thing_with_believable, fact)
    UserOpinionCalculation.new(thing_with_believable.believable) { |u| 1.0 }.opinion
  end

  def opinion_store
    Opinion::Store.new HashStore::Redis.new('FactGraphOpinion')
  end

  delegate :store, :retrieve, to: :opinion_store
end
