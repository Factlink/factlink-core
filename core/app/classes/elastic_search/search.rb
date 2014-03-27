require 'uri'

class ElasticSearch
  module Search
    extend self

    def search(keywords:, types:, page: 1, row_count: 20)
      from = (page - 1) * row_count

      url = ElasticSearch.url +
            "/#{types.join(',')}/" +
            "_search?q=#{process_keywords(keywords)}&from=#{from}&size=#{row_count}&analyze_wildcard=true"

      results = HTTParty.get url
      handle_httparty_error results

      results.parsed_response['hits']['hits']
    end

    private

    def process_keywords keywords
      lucene_special_characters_escaped_keywords(keywords)
        .split(/\s+/)
        .map { |keyword| quoted_if_some_lucene_operators keyword }
        .map { |keyword| URI.escape(keyword) }
        .map { |keyword| "(#{keyword}*+OR+#{keyword})" }
        .join("+AND+")
    end

    def lucene_special_characters_escaped_keywords keywords
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
        "'#{keyword}'"
      else
        keyword
      end
    end

    def handle_httparty_error results
      case results.code
      when 200..299
      when 400..499
        fail "Client error, status code: #{results.code}, response: '#{results.response}'."
      when 500..599
        fail "Server error, status code: #{results.code}, response: '#{results.response}'."
      else
        fail "Unexpected status code: #{results.code}, response: '#{results.response}'."
      end
    end
  end
end
