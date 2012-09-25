class SearchChannelInteractor
  def initialize keywords, user, options={}
    raise 'Keywords should be a string.' unless keywords.kind_of? String
    raise 'Keywords must not be empty.'  unless keywords.length > 0
    raise 'User should be of User type.' unless user.kind_of? User

    @user = user
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
      query = ElasticSearchChannelQuery.new filter_keywords, @page, @row_count
    else
      query = SolrSearchChannelQuery.new filter_keywords, @page, @row_count
    end
    results = query.execute

    results
  end

  private
  def filter_keywords
    @keywords.split(/\s+/).select{|x|x.length > 1}.join(" ")
  end

  def use_elastic_search?
    @ability.can? :see_feature_elastic_search, Ability::FactlinkWebapp
  end

  def authorized?
    @ability.can? :index, Topic
    @ability.can? :show, @user
  end
end
