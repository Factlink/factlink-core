class Fact < Basefact

  set :supporting_facts, FactRelation
  set :weakening_facts, FactRelation

  #scope added to retrieve only facts, not factrelations
  #scope :facts, where(:_type => "Fact")
  
  deprecate
  def fact_relations_ids
    fact_relations.map { |fr| fr.id }
  end
  
  def fact_relations
    supporting_facts.all + weakening_facts.all
  end
  
  def sorted_fact_relations
    res = self.fact_relations.sort { |a, b| a.percentage <=> b.percentage }
    res.reverse
  end
  
  def evidence(type)
    case type
    when :supporting
      supporting_facts
    when :weakening
      weakening_facts
    end
  end
  
  def add_evidence(type, evidence_fact, user)
    fact_relation = FactRelation.get_or_create(evidence_fact, type, self, user)
    evidence(type) << fact_relation
    fact_relation
  end
  
  # Count helpers
  def supporting_evidence_count
    evidence(:supporting).length
  end

  def weakening_evidence_count
    evidence(:weakening).length
  end

  def evidence_count
    fact_relations_ids.count
  end
  
  # Used for sorting
  deprecate
  def self.column_names
    FactData.column_names
  end

  def evidence_opinion
    opinions = []
    [:supporting, :weakening].each do |type|
      factlinks = FactRelation.where(:_id.in => evidence(type).members)
      factlinks.each do |factlink|
        opinions << factlink.get_influencing_opinion
      end
    end
    Opinion.combine(opinions)
  end

  def get_opinion
    user_opinion = super
    user_opinion + evidence_opinion
  end

end