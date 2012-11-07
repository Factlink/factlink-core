class SearchChannelInteractor
  include Pavlov::CanCan
  include Pavlov::SearchHelper

  def initialize keywords, options={}
    raise 'Keywords should be a string.' unless keywords.kind_of? String
    raise 'Keywords must not be empty.'  unless keywords.length > 0

    @keywords = keywords
    @options = options
  end

  def use_query
    :elastic_search_channel
  end

  private
  def keyword_min_length
    1
  end

  def valid_result? result
    true
  end

  def authorized?
    can? :index, Topic
  end
end
