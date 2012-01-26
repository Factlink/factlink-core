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

Authority.calculate_from :Fact do |f|
  [1, FactRelation.find(:from_fact_id => f.id).except(:created_by_id => f.created_by_id).count].max
end

Authority.calculate_from :GraphUser do |gu|
  1.0 + Math.log2(gu.real_created_facts.inject(1) { |result, fact| result * fact.authority})
end


class Fact
  def authority
    Authority.from(self).to_f
  end
end

class GraphUser < OurOhm

  def authority
    Authority.from(self).to_f
  end

  def rounded_authority
    Authority.from(self).to_s
  end


end
