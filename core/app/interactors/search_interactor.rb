class SearchInteractor
  def initialize keywords, options={}
    raise 'Keywords should be an string.' unless keywords.kind_of? String
    raise 'Keywords must not be empty.'   unless keywords.length > 0

    @keywords = keywords
    @ability = options[:ability]
    @page = options[:page] || 1
    @row_count = options[:row_count] || 20
  end

  def execute
    raise CanCan::AccessDenied unless authorized?

    if filter_keywords.length == 0
      return []
    end

    query = ElasticSearchAllQuery.new(filter_keywords, @page, @row_count)

    results = query.execute

    results = results.delete_if do |res|
      res.nil? or
      (res.class == FactData and FactData.invalid(res)) or
      (res.class == User and res.hidden)
    end

    results
  end

  private
  def filter_keywords
    @keywords.split(/\s+/).select{|x|x.length > 2}.join(" ")
  end

  def authorized?
    @ability.can? :index, Fact
  end
end
