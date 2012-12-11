require_relative "elastic_search.rb"

module Queries
  class ElasticSearchAll < Queries::ElasticSearch
    def define_query
      type :factdata
      type :topic
      type :user
    end
  end
end
