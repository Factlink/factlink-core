require 'uri'

module Queries
  class ElasticSearch
    include Pavlov::Query

    arguments :keywords, :page, :row_count

    def execute
      @types = []
      define_query

      from = (page - 1) * row_count

      url = "http://#{FactlinkUI::Application.config.elasticsearch_url}/" +
            "#{@types.join(',')}/" +
            "_search?q=#{processed_keywords}&from=#{from}&size=#{row_count}&analyze_wildcard=true"

      results = HTTParty.get url
      handle_httparty_error results

      hits = results.parsed_response['hits']['hits']

      hits.map do |record|
        get_object(record['_id'], record['_type'])
      end
    end

    def type type_name
      @types << type_name
    end

    private
    def lucene_special_characters_escaped_keywords
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
      lucene_special_characters_escaped_keywords
        .split(/\s+/)
        .map{ |keyword| quoted_if_some_lucene_operators keyword}
        .map{ |keyword| URI.escape(keyword) }
        .map{ |keyword| "(#{keyword}*+OR+#{keyword})"}
        .join("+AND+")
    end

    def handle_httparty_error results
      case results.code
        when 200..299
        when 400..499
          raise "Client error, status code: #{results.code}, response: '#{results.response}'."
        when 500..599
          raise "Server error, status code: #{results.code}, response: '#{results.response}'."
        else
          raise "Unexpected status code: #{results.code}, response: '#{results.response}'."
      end
    end

    def get_object id, type
      case type
      when'factdata'
        FactData.find(id)
      when 'topic'
        old_query :'topics/by_id_with_authority_and_facts_count', id
      when 'user'
        mongoid_user = User.find(id)

        FactlinkUser.map_from_mongoid(mongoid_user)
      when 'test_class'
        TestClass.new(id)
      else
        raise 'Object type unknown.'
      end
    end
  end
end
