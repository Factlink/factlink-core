class Fact < Basefact

  set :supporting_facts, FactRelation
  set :weakening_facts, FactRelation

  # More Rails like behaviour:
  # def Fact.first
  #   return Fact.all.first
  # end
  # def Fact.last
  #   case Fact.all.count
  #   when 0
  #     return nil
  #   when 1
  #     return Fact.first
  #   else
  #     return Fact.all.to_a[Fact.all.count - 1]
  #   end
  # end
  
  # OHm Model needs to have a definition of which fields to render
  def to_hash
    super.merge(:_id => id, :displaystring => displaystring, :score_dict_as_percentage => score_dict_as_percentage)
  end
  
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
    evidence(:supporting).size
  end

  def weakening_evidence_count
    evidence(:weakening).size
  end

  def evidence_count
    weakening_evidence_count + supporting_evidence_count
  end
  
  # Used for sorting
  deprecate
  def self.column_names
    FactData.column_names
  end

  def evidence_opinion
    opinions = []
    [:supporting, :weakening].each do |type|
      factlinks = evidence(type)
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