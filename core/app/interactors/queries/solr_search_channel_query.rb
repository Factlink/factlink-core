class SolrSearchChannelQuery
  def initialize keywords
    @keywords = keywords
  end

  def execute
    keywords_local_copy = @keywords
    solr_result = Sunspot.search Topic do
      keywords keywords_local_copy
    end

    solr_result.results
  end
end
