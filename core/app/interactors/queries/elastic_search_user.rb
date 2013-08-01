module Queries
  class ElasticSearchUser < Queries::ElasticSearch
    def define_query
      type :user
    end
  end
end
