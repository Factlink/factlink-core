class FactDataObserver < Mongoid::Observer

  def after_create fact_data
    ElasticSearchIndexFactDataForTextSearch.new(fact_data).execute
  end

  def after_update fact_data
    if fact_data.changed? and not (fact_data.changed & ['title', 'displaystring']).empty?
      ElasticSearchIndexFactDataForTextSearch.new(fact_data).execute
    end
  end

  def after_destroy fact_data
    ElasticSearchDeleteFactDataForTextSearch.new(fact_data).execute
  end

end
