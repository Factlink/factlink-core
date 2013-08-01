require_relative '../util/search'

module Interactors
  class SearchChannel
    include Pavlov::Interactor
    include Util::CanCan
    include Util::Search

    arguments :keywords

    def validate
      validate_nonempty_string :keywords, keywords
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
