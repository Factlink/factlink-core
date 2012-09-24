class ElasticSearchChannelQuery
  def initialize keywords
    @keywords = keywords
  end

  def execute
    keywords_local_copy = @keywords

    url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/topic/_search?q=#{wildcardify_keywords}"
    puts url
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
