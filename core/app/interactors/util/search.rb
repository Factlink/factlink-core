module Util
  module Search
    def keywords_longer_than_chars(keywords, nr)
      keywords.split(/\s+/).select { |x|x.length > nr }.join(" ")
    end

    def search_with query_name
      fail Pavlov::AccessDenied unless authorized?
      return [] if filtered_keywords.length == 0

      page = @page || 1
      row_count = @row_count || 20

      results = query query_name, keywords: filtered_keywords, page: page, row_count: row_count
      results.select { |result| valid_result? result }
    end

    def filtered_keywords
      keywords_longer_than_chars @keywords, (keyword_min_length-1)
    end

    def execute
      search_with(use_query)
    end
  end
end
