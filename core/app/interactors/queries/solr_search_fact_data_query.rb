require 'logger'

class SolrSearchFactDataQuery
  def initialize keywords, page, row_count, options={}
    @keywords = keywords
    @page = page
    @row_count = row_count
    @logger = options[:logger] || Logger.new(STDERR)
  end

  def execute
    local_keywords_copy = @keywords

    results = Sunspot.search FactData do
      fulltext local_keywords_copy do
        highlight :displaystring
      end
    end

   results.results
  end
end
