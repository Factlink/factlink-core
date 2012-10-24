class SearchEvidenceInteractor
  def initialize keywords, fact_id, options={}
    raise 'Keywords should be an string.' unless keywords.kind_of? String
    raise 'Fact_id should be an number.' unless /\A\d+\Z/.match fact_id

    @keywords = keywords
    @fact_id = fact_id
    @page = options[:page] || 1
    @row_count = options[:row_count] || 20
    @ability = options[:ability]
  end

  def execute
    raise Pavlov::AccessDenied unless authorized?

    if filter_keywords.length == 0
      return []
    end

    query = Queries::ElasticSearchFactData.new(filter_keywords, @page, @row_count)

    results = query.execute

    filter_results results
  end

  private
  def filter_keywords
    @keywords.split(/\s+/).select{|x|x.length > 2}.join(" ")
  end

  def filter_results results
    results.
      select {|result| FactData.valid(result) and result.fact.id != @fact_id}
  end

  def authorized?
    @ability.can? :index, Fact
  end
end
