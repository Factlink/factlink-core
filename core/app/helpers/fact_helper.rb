module FactHelper

  # IE 8 max url length is 2083 characters according to
  # http://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url
  def friendly_fact_with_opened_tab_path(fact, tab_type)
    "#{friendly_fact_path(fact)}?tab=#{tab_type}"
  end

  def friendly_fact_path(fact, max_slug_length = 1024)
    # Obsolete method
    dead_fact = Pavlov.old_query :'facts/get_dead', fact.id.to_s
    FactUrl.new(dead_fact).friendly_fact_path
  end

  def friendly_fact_with_opened_tab_url(fact, tab_type)
    "#{friendly_fact_url(fact)}?tab=#{tab_type}"
  end

  def friendly_fact_url(fact, max_slug_length = 1024)
    # Obsolete method
    dead_fact = Pavlov.old_query :'facts/get_dead', fact.id.to_s
    FactUrl.new(dead_fact).friendly_fact_url
  end
end
