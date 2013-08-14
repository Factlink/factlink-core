require_relative "elastic_search.rb"

module Queries
  class ElasticSearchFactData
    include Pavlov::Query

    arguments :keywords, :page, :row_count

    private

    def execute
      query :'elastic_search',
        keywords: keywords,
        page: page,
        row_count: row_count,
        types: [:factdata]
    end

    def validate
      raise 'Keywords must not be empty' unless @keywords.length > 0
    end
  end
end
