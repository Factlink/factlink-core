Basefact.opinion_reference :user_opinion do |depth|
  #depth has no meaning here unless we want the depth to also recalculate authorities
  opinions = []
  [:believes, :doubts, :disbelieves].each do |type|
    opiniated = opiniated(type)
    opiniated.each do |user|
      opinions << Opinion.for_type(type, user.authority)
    end
  end
  Opinion.combine(opinions)
end

Fact.opinion_reference :evidence_opinion do |depth|
  opinions = evidence(:both).map { |fr| fr.get_influencing_opinion(depth-1) }
  Opinion.combine(opinions)
end

Fact.opinion_reference :opinion do |depth|
  self.get_user_opinion(depth) + self.get_evidence_opinion( depth < 1 ? 1 : depth )
end


FactRelation.opinion_reference :influencing_opinion do |depth|
  get_type_opinion.dfa(self.from_fact.get_opinion(depth), self.get_user_opinion(depth))
end

class FactRelation
  alias :get_opinion :get_user_opinion
  alias :calculate_opinion :calculate_user_opinion
end



# authority

class Fact
  attribute :cached_incluencing_authority
  def calculate_influencing_authority
    self.cached_incluencing_authority = [1, FactRelation.find(:from_fact_id => self.id).except(:created_by_id => self.created_by_id).count].max
    self.save
  end
  def influencing_authority
    [(self.cached_incluencing_authority.to_f || 1.0), 1.0].max
  end
end