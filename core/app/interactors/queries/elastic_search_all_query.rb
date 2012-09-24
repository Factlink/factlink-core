class ElasticSearchAllQuery
  def initialize keywords, page, row_count, options = {}
    @keywords = keywords
    @page = page
    @row_count = row_count
  end

  def execute
    from = (@page - 1) * @row_count
    url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/_search?q=#{@keywords}&from=#{from}&size=#{@row_count}"
    puts url
    results = HTTParty.get url
    puts results
  end
end
