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
    raise Pavlov::AccessDenied unless authorized?

    if filter_keywords.length == 0
      return []
    end

    query = Queries::ElasticSearchChannel.new filter_keywords, @page, @row_count

    results = query.execute

    results
  end

  private
  def filter_keywords
    @keywords.split(/\s+/).select{|x|x.length > 1}.join(" ")
  end

  def authorized?
    (@ability.can? :index, Topic) and (@ability.can? :show, @user)
  end
end
