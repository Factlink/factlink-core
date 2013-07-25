class FactGraph
  def self.recalculate
    new.recalculate
  end

  def recalculate
    calculate_authority
    calculate_user_opinions
    calculate_graph
  end

  def calculate_fact_when_user_opinion_changed(fact)
    user_opinion = real_calculate_user_opinion(fact)
    opinion_store.store :Fact, fact.id, :user_opinion, user_opinion
  end

  def calculate_authority
    Authority.run_calculation(authority_calculators)
  end

  def calculate_fact_relation_when_user_opinion_changed(fact_relation)
    user_opinion = real_calculate_user_opinion(fact_relation)
    opinion_store.store :FactRelation, fact_relation.id, :user_opinion, user_opinion
  end

  def user_opinion_for_fact(fact)
    opinion_store.retrieve :Fact, fact.id, :user_opinion
  end

  def user_opinion_for_fact_relation(fact_relation)
    opinion_store.retrieve :FactRelation, fact_relation.id, :user_opinion
  end

  def opinion_for_fact(fact)
    user_opinion = opinion_store.retrieve :Fact, fact.id, :user_opinion
    evidence_opinion = opinion_store.retrieve :Fact, fact.id, :evidence_opinion

    user_opinion + evidence_opinion
  end

  private

  def calculate_user_opinions
    Fact.all.each do |fact|
      user_opinion = real_calculate_user_opinion(fact)
      opinion_store.store :Fact, fact.id, :user_opinion, user_opinion
    end

    FactRelation.all.each do |fact_relation|
      user_opinion = real_calculate_user_opinion(fact_relation)
      opinion_store.store :FactRelation, fact_relation.id, :user_opinion, user_opinion
    end
  end

  def calculate_graph
    5.times do |i|
      Fact.all.each do |fact|
        influencing_opinions = fact.fact_relations.all.map do |fact_relation|
          from_fact_opinion = opinion_for_fact(fact_relation.from_fact)
          user_opinion = opinion_store.retrieve :FactRelation, fact_relation.id, :user_opinion
          evidence_type = OpinionType.for_relation_type(fact_relation.type)

          real_calculate_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)
        end

        evidence_opinion = DeadOpinion.combine(influencing_opinions)
        opinion_store.store :Fact, fact.id, :evidence_opinion, evidence_opinion
      end
    end
  end

  def real_calculate_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)
    net_fact_authority = from_fact_opinion.net_authority
    net_relevance_authority = user_opinion.net_authority
    authority = [[net_fact_authority, net_relevance_authority].min, 0].max

    DeadOpinion.for_type(evidence_type, authority)
  end

  def opinion_store
    Opinion::Store.new HashStore::Redis.new
  end

  def real_calculate_user_opinion(base_fact)
    UserOpinionCalculation.new(base_fact.believable) do |user|
      Authority.on(base_fact, for: user).to_f + 1.0
    end.opinion
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
