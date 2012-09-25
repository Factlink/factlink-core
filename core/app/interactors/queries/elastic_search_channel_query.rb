require 'logger'

class ElasticSearchChannelQuery
  def initialize keywords, page, row_count, options = {}
    @keywords = keywords
    @page = page
    @row_count = row_count
    @logger = options[:logger] || Logger.new(STDERR)
  end

  def execute
    from = (@page - 1) * @row_count

    url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/topic/_search?q=#{wildcardify_keywords}&from=#{from}&size=#{@row_count}"
    results = HTTParty.get url
    handle_httparty_error results

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

  def wildcardify_keywords
    @keywords.split(/\s+/).map{|x| "*#{x}*"}.join(" ")
  end

  def handle_httparty_error results
    case results.code
      when 200..299
      when 400..499
        error = "Client error, status code: #{results.code}, response: '#{results.response}'."
      when 500..599
        error = "Server error, status code: #{results.code}, response: '#{results.response}'."
      else
        error = "Unexpected status code: #{results.code}, response: '#{results.response}'."
    end

    if error
      @logger.error(error)
      raise error
    end
  end
end
