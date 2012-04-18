module FactHelper
  def friendly_fact_path(fact)
    slug = fact.to_s.blank? ? fact.id : fact.to_s.parameterize
    frurl_fact_path(slug, fact.id)
  end

  def top_facts(nr)
    Fact.top(nr).delete_if {|f| Fact.invalid(f)}
  end
end