class FactDataObserver < Mongoid::Observer

  def after_create fact_data
    IndexFactDataForTextSearch.new(fact_data).execute
  end

  def after_update fact_data
    if fact_data.changed? and (fact_data.changed & ['title', 'displaystring']).not_empty?
      IndexFactDataForTextSearch.new(fact_data).execute
    end
  end

  def after_destroy fact_data
  end

end
