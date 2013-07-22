require 'pavlov'
require 'uri'

module Queries
  class ElasticSearch
    include Pavlov::Query

    arguments :keywords, :page, :row_count

    def initialize *arguments
      super
      @types = []
      @logger = @options[:logger] || Logger.new(STDERR)
      define_query
    end

    def execute
      from = (@page - 1) * @row_count

      url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/" +
            "#{@types.join(',')}/" +
            "_search?q=#{processed_keywords}&from=#{from}&size=#{@row_count}&analyze_wildcard=true"

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
    def lucene_special_characters_escaped keywords
      # escaping && and || gives errors, use case is not so important, so removing.
      keywords.gsub('&&', ' ')
              .gsub('||', ' ')
              .gsub(/\+|\-|\!|\(|\)|\{|\}|\[|\]|\^|\~|\*|\?|\:|\\/) do |x|
       '\\' + x
      end
    end

    def quoted_if_some_lucene_operators keyword
      # http://lucene.apache.org/core/old_versioned_docs/versions/3_5_0/queryparsersyntax.html#Escaping%20Special%20Characters
      # NOT and AND and OR could be interpreted as operators, maybe wildcard search for them doesn't work
      if ['NOT', 'AND', 'OR'].include? keyword
        return "'#{keyword}'"
      else
        keyword
      end
    end

    def processed_keywords
      keywords = lucene_special_characters_escaped(@keywords)
      keywords.
        split(/\s+/).
        map{ |keyword| quoted_if_some_lucene_operators keyword}.
        map{ |keyword| URI.escape(keyword) }.
        map{ |keyword| "(#{keyword}*+OR+#{keyword})"}.
        join("+AND+")
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
      if type == 'factdata'
        return FactData.find(id)
      elsif type == 'topic'
        return query :'topics/by_id_with_authority_and_facts_count', id
      elsif type == 'user'
        mongoid_user = User.find(id)

        return FactlinkUser.map_from_mongoid(mongoid_user)
      elsif type == 'test_class'
        obj = TestClass.new
        obj.id=id
        return obj
      end
      raise 'Object type unknown.'
    end
  end
end
