class SearchChannelInteractor
  def initialize keywords, user, options={}
    raise 'Keywords should be a string.' unless keywords.kind_of? String
    raise 'Keywords must not be empty.'  unless keywords.length > 0
    raise 'User should be of User type.' unless user.kind_of? User

    @user = user
    @keywords = keywords
    @ability = options[:ability]
  end

  def authorized?
    @ability.can? :index, Topic
    @ability.can? :show, @user
  end

  def execute
    raise CanCan::AccessDenied unless authorized?

    query = SolrSearchChannelQuery.new @keywords
    results = query.execute
  end
end
