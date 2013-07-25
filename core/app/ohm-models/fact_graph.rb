class FactGraph
  def self.recalculate
    new.recalculate
  end

  def recalculate
    calculate_authority

    calculate_user_opinions_of_all_base_facts
    5.times do |i|
      calculate_fact_relation_influencing_opinions i

      calculate_fact_opinions i
    end
  end

  def calculate_fact_relation_influencing_opinions i
    FactRelation.all.ids.each do |id|
      fr = FactRelation[id]
      Opinion::FactRelationCalculation.new(fr).calculate_influencing_opinion
    end
  end

  def calculate_fact_opinions i
    Fact.all.ids.each do |id|
      fact = Fact[id]
      calculate_fact_opinion(fact, false, true)
    end
  end

  def calculate_user_opinions_of_all_base_facts
    Basefact.all.ids.each do |id|
      bf = Basefact[id]
      Opinion::BaseFactCalculation.new(bf).calculate_user_opinion
    end
  end

  def calculate_fact_opinion(fact, should_calculate_user_opinion, should_calculate_evidence_opinion)
    if should_calculate_user_opinion
      user_opinion = Opinion::BaseFactCalculation.new(fact).calculate_user_opinion
    else
      user_opinion = Opinion::BaseFactCalculation.new(fact).get_user_opinion
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

  def get_influencing_opinions(fact)
    fact.evidence(:both).map do |fr|
      Opinion::FactRelationCalculation.new(fr).get_influencing_opinion
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

  def calculate_fact_when_user_authority_changed(fact)
    calculate_fact_opinion(fact, true, false)
  end

  def calculate_authority
    Authority.run_calculation(authority_calculators)
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
