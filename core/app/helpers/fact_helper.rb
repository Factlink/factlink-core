module FactHelper

  # IE 8 max url length is 2083 characters according to
  # http://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url
  def friendly_fact_with_opened_tab_path(fact, tab_type)
    "#{friendly_fact_path(fact)}?tab=#{tab_type}"
  end

  def friendly_fact_path(fact, max_slug_length = 1024)
    slug = friendly_fact_slug(fact, max_slug_length)
    frurl_fact_path(slug, fact.id)
  end

  def friendly_fact_with_opened_tab_url(fact, tab_type)
    "#{friendly_fact_url(fact)}?tab=#{tab_type}"
  end

  def friendly_fact_url(fact, max_slug_length = 1024)
    slug = friendly_fact_slug(fact, max_slug_length)
    frurl_fact_url(slug, fact.id)
  end

  def friendly_fact_slug(fact, max_slug_length = 1024)
    return fact.id if fact.to_s.blank?

    fact.to_s.parameterize.slice(0,max_slug_length)
  end
end
