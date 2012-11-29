module Interactors
class Search
  include Pavlov::Interactor
  include Pavlov::CanCan
  include Pavlov::SearchHelper

  arguments :keywords

  def validate
    raise 'Keywords should be an string.' unless @keywords.kind_of? String
    raise 'Keywords must not be empty.'   unless @keywords.length > 0
  end

  def use_query
    :elastic_search_all
  end

  def valid_result?(res)
    not invalid_result?(res)
  end

  def invalid_result?(res)
      res.nil? or
      (res.class == FactData and FactData.invalid(res)) or
      (res.class == User and res.hidden)
  end

  def keyword_min_length
    2
  end

  def authorized?
    can? :index, Fact
  end
end
end
