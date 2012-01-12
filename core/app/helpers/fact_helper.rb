module FactHelper
  def friendly_fact_path(fact)
    frurl_fact_path(fact.to_s.parameterize, fact.id)
  end
end