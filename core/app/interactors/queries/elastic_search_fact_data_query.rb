class ElasticSearchFactDataQuery
  def initialize keywords, page, row_count, options = {}
    @keywords = keywords
    @page = page
    @row_count = row_count
  end

  def execute
    from = (@page - 1) * @row_count
    url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/factdata/_search?q=#{wildcardify_keywords}&from=#{from}&size=#{@row_count}"

    results = HTTParty.get url
    hits = results.parsed_response['hits']['hits']

    result_objects = []

    hits.each do |record|
      result_objects << FactData.find(record['_id'])
    end
    result_objects
  end

  private
  def wildcardify_keywords
    @keywords.split(/\s+/).map{|x| "*#{x}*"}.join(" ")
  end
end
