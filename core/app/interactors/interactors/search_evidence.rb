module Interactors
class SearchEvidence
  include Pavlov::Interactor
  include Pavlov::CanCan
  include Pavlov::SearchHelper

  arguments :keywords, :fact_id

  def validate
    raise 'Keywords should be an string.' unless @keywords.kind_of? String
    raise 'Fact_id should be an number.' unless /\A\d+\Z/.match @fact_id
  end

  def use_query
    :elastic_search_fact_data
  end

  def keyword_min_length
    2
  end

  def valid_result? result
    FactData.valid(result) and result.fact.id != @fact_id
  end

  def authorized?
    can? :index, Fact
  end
end
end
