require_relative '../util/search'

module Interactors
  class SearchChannel
    include Pavlov::Interactor
    include Util::CanCan
    include Util::Search

    arguments :keywords

    def validate
      raise 'Keywords should be a string.' unless @keywords.kind_of? String
      raise 'Keywords must not be empty.'  unless @keywords.length > 0
    end

    def use_query
      :elastic_search_channel
    end

    def keyword_min_length
      1
    end

    def valid_result? result
      not result.nil?
    end

    def authorized?
      can? :index, Topic
    end
  end
end
