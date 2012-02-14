module FactHelper
  def friendly_fact_path(fact)
    slug = fact.to_s.blank? ? fact.id : fact.to_s.parameterize
    frurl_fact_path(slug, fact.id)
  end
end