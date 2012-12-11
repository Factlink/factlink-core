require_relative '../pavlov'
require 'cgi'

module Queries
  class ElasticSearch
    include Pavlov::Query

    arguments :keywords, :page, :row_count

    def finish_initialize
      @types = []
      @logger = @options[:logger] || Logger.new(STDERR)
      define_query
    end

    def execute
      from = (@page - 1) * @row_count

      url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/#{@types.join(',')}/_search?q=#{processed_keywords}&from=#{from}&size=#{@row_count}&default_operator=AND"
      puts url
      results = HTTParty.get url
      handle_httparty_error results

      hits = results.parsed_response['hits']['hits']

      result_objects = []

      hits.each do |record|
        result_objects << get_object(record['_id'], record['_type'])
      end
      result_objects
    end

    def type type_name
      @types << type_name
    end

    private
    def processed_keywords
      @keywords.split(/\s+/).
        map{ |x| CGI::escape(x) }.
        map{ |x| "(#{x}*%20OR%20#{x})"}.
        join("+")
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

    def get_object id, type
      if(type == 'factdata')
        return FactData.find(id)
      elsif (type == 'topic')
        return Topic.find(id)
      elsif (type == 'user')
        return User.find(id)
      end
      raise 'Object type unknown.'
    end
  end
end
