module FactHelper

  # IE 8 max url length is 2083 characters according to
  # http://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url
  def friendly_fact_path(fact, max_slug_length = 1024)
    slug = fact.to_s.blank? ? fact.id : fact.to_s.parameterize.slice(0,max_slug_length)
    frurl_fact_path(slug, fact.id)
  end

  def friendly_fact_url(fact, max_slug_length = 1024)
    slug = fact.to_s.blank? ? fact.id : fact.to_s.parameterize.slice(0,max_slug_length)
    frurl_fact_url(slug, fact.id)
  end
end
