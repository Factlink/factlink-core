class FactDataObserver < Mongoid::Observer
  include Pavlov::Helpers

  def after_create fact_data
    command :elastic_search_index_fact_data_for_text_search, fact_data
  end

  def after_update fact_data
    if fact_data.changed? and not (fact_data.changed & ['title', 'displaystring']).empty?
      command :elastic_search_index_fact_data_for_text_search, fact_data
    end
  end

  def after_destroy fact_data
    command :elastic_search_delete_fact_data_for_text_search, fact_data
  end

end
