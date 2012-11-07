class SearchUserInteractor
  include Pavlov::Operation
  include Pavlov::CanCan
  include Pavlov::SearchHelper

  arguments :keywords
  def validate
    raise 'Keywords should be a string.' unless @keywords.kind_of? String
    raise 'Keywords must not be empty.'  unless @keywords.length > 0
  end

  def use_query
    :elastic_search_user
  end

  def valid_result? result
    true
  end

  def keyword_min_length
    1
  end

  def authorized?
    can? :index, Topic
  end
end
