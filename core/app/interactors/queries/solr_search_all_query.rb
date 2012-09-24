require 'logger'

class SolrSearchAllQuery
  def initialize keywords, page, row_count, options = {}
    @keywords = keywords
    @page = page
    @row_count = row_count
    @logger = options[:logger] || Logger.new(STDERR)
  end

  def execute
    local_keywords_copy = @keywords

    results = Sunspot.search FactData, User, Topic do
      keywords local_keywords_copy

      paginate :page => @page || 1, :per_page => @row_count
    end

    # TODO: This message gets lost easily in history, what are the options?
    if results.hits.count > results.results.count
      @logger.error "SOLR Search index is out of sync, please run 'rake sunspot:index'."
    end

    results.results
  end
end
