class ElasticSearchChannelQuery
  def initialize keywords, page, row_count
    @keywords = keywords
    @page = page
    @row_count = row_count
  end

  def execute
    from = (@page - 1) * @row_count

    url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/topic/_search?q=#{wildcardify_keywords}&from=#{from}&size=#{@row_count}"
    results = HTTParty.get url
    hits = results.parsed_response['hits']['hits']

    result_objects = []

    hits.each do |record|
      result_objects << get_object(record['_id'])
    end
    result_objects
  end

  private
  def get_object id
    return Topic.find(id)
  end

  private
  def wildcardify_keywords
    @keywords.split(/\s+/).map{|x| "*#{x}*"}.join(" ")
  end
end
