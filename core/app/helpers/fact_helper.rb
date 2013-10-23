module FactHelper

  # IE 8 max url length is 2083 characters according to
  # http://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url

  def friendly_fact_path(fact, max_slug_length = 1024)
    # Obsolete method
    dead_fact = Pavlov.query :'facts/get_dead', id: fact.id.to_s
    FactUrl.new(dead_fact).friendly_fact_path
  end

  def friendly_fact_url(fact, max_slug_length = 1024)
    # Obsolete method
    dead_fact = Pavlov.query :'facts/get_dead', id: fact.id.to_s
    FactUrl.new(dead_fact).friendly_fact_url
  end
end
