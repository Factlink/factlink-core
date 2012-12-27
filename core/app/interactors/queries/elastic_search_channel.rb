require_relative "elastic_search.rb"

module Queries
  class ElasticSearchChannel < Queries::ElasticSearch
    def define_query
      type :topic
    end
  end
end
