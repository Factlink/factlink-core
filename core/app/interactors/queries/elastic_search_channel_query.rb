require 'logger'
require_relative "elastic_search.rb"

class ElasticSearchChannelQuery < ElasticSearch
  def initialize keywords, page, row_count, options = {}
    @keywords = keywords
    @page = page
    @row_count = row_count
    @logger = options[:logger] || Logger.new(STDERR)
  end

  def execute
    from = (@page - 1) * @row_count

    url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/topic/_search?q=#{process_keywords}&from=#{from}&size=#{@row_count}"
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
  # TODO: Refactor to Query
  def get_object id
    return Topic.find(id)
  end

end
