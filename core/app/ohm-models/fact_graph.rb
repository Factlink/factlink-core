class FactGraph
  def self.recalculate
    new.recalculate
  end

  def debug x
    @logger ||= Logger.new(STDERR)
    @logger.info "#{Time.now} #{x}"
    $stdout.flush
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
    debug "Calculating fact relation influencing opinions (#{i})"
    FactRelation.all.ids.each do |id|
      fr = FactRelation[id]
      Opinion::FactRelationCalculation.new(fr).calculate_influencing_opinion
    end
  end

  def calculate_fact_opinions i
    debug "Calculating fact opinions (#{i})"
    Fact.all.ids.each do |id|
      fact = Fact[id]
      fact_calculation = Opinion::FactCalculation.new(fact)

      influencing_opinions = get_influencing_opinions(fact)
      evidence_opinion = real_calculate_evidence_opinion(influencing_opinions)
      opinion_store.store :Fact, fact.id, :evidence_opinion, evidence_opinion

      fact_calculation.calculate_opinion
    end
  end

  def calculate_user_opinions_of_all_base_facts
    debug "Calculating user opinions on basefacts"
    Basefact.all.ids.each do |id|
      bf = Basefact[id]
      Opinion::BaseFactCalculation.new(bf).calculate_user_opinion
    end
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

  def calculate_authority
    debug "Calculating Authority"
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
