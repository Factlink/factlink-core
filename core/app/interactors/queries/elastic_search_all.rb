require 'logger'
require_relative "elastic_search.rb"

module Queries
  class ElasticSearchAll < ElasticSearch
    def initialize keywords, page, row_count, options = {}
      @keywords = keywords
      @page = page
      @row_count = row_count
      @logger = options[:logger] || Logger.new(STDERR)
    end

    def execute
      from = (@page - 1) * @row_count

      url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/_search?q=#{processed_keywords}&from=#{from}&size=#{@row_count}&default_operator=AND"

      results = HTTParty.get url
      handle_httparty_error results

      hits = results.parsed_response['hits']['hits']

      result_objects = []

      hits.each do |record|
        result_objects << get_object(record['_id'], record['_type'])
      end
      result_objects
    end

    private
    # TODO: Refactor to Queries
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
