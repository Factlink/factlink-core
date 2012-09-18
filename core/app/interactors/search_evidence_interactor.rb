class SearchEvidenceInteractor
  def initialize keywords, fact_id, options={}
    raise 'keywords should be an string.' unless keywords.kind_of? String
    raise 'keywords must not be empty'    unless keywords.length > 0
    raise 'fact_id should be an integer.' unless /\A\d+\Z/.match fact_id

    @keywords = keywords
    @fact_id = fact_id
    @ability = options[:ability]
  end

  def authorized?
    @ability.can? :index, Fact
  end

  def execute
    raise CanCan::AccessDenied unless authorized?

    keywords = filter_keywords

    if keywords.length == 0
      return []
    end

    solr_result = Sunspot.search FactData do
      fulltext keywords do
        highlight :displaystring
      end
    end

   filter_results solr_result.results
  end

  def filter_keywords
    @keywords.split(/\s+/).select{|x|x.length > 2}.join(" ")
  end

  def filter_results results
    results.
      select {|result| FactData.valid(result) and result.fact.id != @fact_id}
  end
end
