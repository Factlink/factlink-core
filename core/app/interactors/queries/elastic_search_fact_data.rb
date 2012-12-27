require_relative "elastic_search.rb"

module Queries
  class ElasticSearchFactData < Queries::ElasticSearch
    def define_query
      type :factdata
    end

    def validate
      raise 'Keywords must not be empty' unless @keywords.length > 0
    end
  end
end
