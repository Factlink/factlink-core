require_relative "elastic_search.rb"

module Queries
  class ElasticSearchChannel < ElasticSearch
    def define_query
      type :topic
    end
  end
end
