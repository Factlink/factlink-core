require_relative '../util/search'
require_relative '../util/can_can'

module Interactors
  class SearchUser
    include Pavlov::Operation
    include Util::CanCan
    include Util::Search

    arguments :keywords

    def validate
      fail 'Keywords should be a string.' unless @keywords.kind_of? String
      fail 'Keywords must not be empty.'  unless @keywords.length > 0
    end

    def use_query
      :elastic_search_user
    end

    def valid_result? result
      not( result.nil? or result.hidden? )
    end

    def keyword_min_length
      1
    end

    def authorized?
      can? :index, Topic
    end
  end
end
