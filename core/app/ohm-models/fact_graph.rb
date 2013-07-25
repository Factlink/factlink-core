class FactGraph
  def self.recalculate
    new.recalculate
  end

  def recalculate
    calculate_authority

    Fact.all.each do |fact|
      Opinion::BaseFactCalculation.new(fact).calculate_user_opinion
    end

    FactRelation.all.each do |fact_relation|
      Opinion::BaseFactCalculation.new(fact_relation).calculate_user_opinion
    end

    5.times do |i|
      FactRelation.all.each do |fact_relation|
        calculate_influencing_opinion(fact_relation)
      end

      Fact.all.each do |fact|
        calculate_fact_opinion(fact, false, true)
      end
    end
  end

  def calculate_fact_when_user_opinion_changed(fact)
    calculate_fact_opinion(fact, true, false)
  end

  def calculate_authority
    Authority.run_calculation(authority_calculators)
  end

  def calculate_fact_relation_when_user_opinion_changed(fact_relation)
    Opinion::BaseFactCalculation.new(fact_relation).calculate_user_opinion
  end

  private

  def calculate_fact_opinion(fact, should_calculate_user_opinion, should_calculate_evidence_opinion)
    if should_calculate_user_opinion
      user_opinion = Opinion::BaseFactCalculation.new(fact).calculate_user_opinion
    else
      user_opinion = opinion_store.retrieve :Fact, fact.id, :user_opinion
    end

    if should_calculate_evidence_opinion
      influencing_opinions = get_influencing_opinions(fact)
      evidence_opinion = real_calculate_evidence_opinion(influencing_opinions)
      opinion_store.store :Fact, fact.id, :evidence_opinion, evidence_opinion
    else
      evidence_opinion = opinion_store.retrieve :Fact, fact.id, :evidence_opinion
    end

    opinion = real_calculate_opinion(user_opinion, evidence_opinion)

    opinion_store.store :Fact, fact.id, :opinion, opinion
  end

  def calculate_influencing_opinion(fact_relation)
    from_fact_opinion = opinion_store.retrieve :Fact, fact_relation.from_fact.id, :opinion
    user_opinion = opinion_store.retrieve :FactRelation, fact_relation.id, :user_opinion
    evidence_type = OpinionType.for_relation_type(fact_relation.type)

    influencing_opinion = real_calculate_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)

    opinion_store.store :FactRelation, fact_relation.id, :influencing_opinion, influencing_opinion
  end

  def real_calculate_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)
    net_fact_authority = from_fact_opinion.net_authority
    net_relevance_authority = user_opinion.net_authority
    authority = [[net_fact_authority, net_relevance_authority].min, 0].max

    DeadOpinion.for_type(evidence_type, authority)
  end

  def get_influencing_opinions(fact)
    fact.evidence(:both).map do |fact_relation|
      opinion_store.retrieve :FactRelation, fact_relation.id, :influencing_opinion
    end
  end

  def real_calculate_evidence_opinion(influencing_opinions)
    DeadOpinion.combine(influencing_opinions)
  end

  def opinion_store
    Opinion::Store.new HashStore::Redis.new
  end

  def real_calculate_opinion(user_opinion, evidence_opinion)
    user_opinion + evidence_opinion
  end

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
