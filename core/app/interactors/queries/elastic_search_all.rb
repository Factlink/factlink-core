require_relative "elastic_search.rb"

module Queries
  class ElasticSearchAll
    include Pavlov::Query

    arguments :keywords, :page, :row_count

    private

    def execute
      query :'elastic_search',
        keywords: keywords,
        page: page,
        row_count: row_count,
        types: [:factdata, :topic, :user]
    end
  end
end
