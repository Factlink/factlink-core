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

    if use_elastic_search?
      query = ElasticSearchAllQuery.new(filter_keywords, @page, @row_count)
    else
      query = SolrSearchAllQuery.new(filter_keywords, @page, @row_count)
    end
    results = query.execute

    results = results.delete_if do |res|
      (res.class == FactData and FactData.invalid(res)) or
      (res.class == User and (res.nil? or res.hidden))
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

  def use_elastic_search?
    @ability.can? :see_feature_elastic_search, Ability::FactlinkWebapp
  end
end
