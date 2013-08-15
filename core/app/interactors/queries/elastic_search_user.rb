module Queries
  class ElasticSearchUser
    include Pavlov::Query

    arguments :keywords, :page, :row_count

    private

    def execute
      query :'elastic_search',
        keywords: keywords,
        page: page,
        row_count: row_count,
        types: [:user]
    end

  end
end
