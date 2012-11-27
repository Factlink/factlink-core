require_relative "elastic_search.rb"

module Queries
  class ElasticSearchUser < ElasticSearch
    def define_query
      type :user
    end
  end
end
