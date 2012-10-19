require 'logger'
require_relative "elastic_search.rb"

module Queries
  class ElasticSearchFactData < ElasticSearch
    def define_query
      type :factdata
      @keywordsArray = @keywordsArray.map{ |x| x.length<=3?x:"*#{x}*"}
    end

    def validate
      raise 'Keywords must not be empty' unless @keywords.length > 0
    end
  end
end
