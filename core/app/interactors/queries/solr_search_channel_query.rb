class SolrSearchChannelQuery
  def initialize keywords, page, row_count
    @keywords = keywords
    @page = page
    @row_count = row_count
  end

  def execute
    keywords_local_copy = @keywords
    solr_result = Sunspot.search Topic do
      keywords keywords_local_copy

      paginate :page => @page || 1, :per_page => @row_count
    end

    solr_result.results
  end
end
