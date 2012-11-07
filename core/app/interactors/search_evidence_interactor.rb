class SearchEvidenceInteractor
  include Pavlov::CanCan
  include Pavlov::SearchHelper

  def initialize keywords, fact_id, options={}
    raise 'Keywords should be an string.' unless keywords.kind_of? String
    raise 'Fact_id should be an number.' unless /\A\d+\Z/.match fact_id

    @keywords = keywords
    @fact_id = fact_id
    @options = options
  end

  def execute
    search_with(:elastic_search_fact_data)
  end

  private
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
