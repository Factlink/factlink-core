class ElasticSearchAllQuery
  def initialize keywords, page, row_count, options = {}
    @keywords = keywords
    @page = page
    @row_count = row_count
  end

  def execute
    from = (@page - 1) * @row_count
    url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/_search?q=#{wildcardify_keywords}&from=#{from}&size=#{@row_count}"

    results = HTTParty.get url
    hits = results.parsed_response['hits']['hits']

    result_objects = []

    hits.each do |record|
      result_objects << get_object(record['_id'], record['_type'])
    end
    result_objects
  end

  private
  def get_object id, type
    if(type == 'factdata')
      return FactData.find(id)
    end
    if (type == 'topic')
      return Topic.find(id)
    end
    if (type == 'user')
      return User.find(id)
    end
    raise 'Object type unknown.'
  end

  private
  def wildcardify_keywords
    @keywords.split(/\s+/).map{|x| "*#{x}*"}.join(" ")
  end
end
