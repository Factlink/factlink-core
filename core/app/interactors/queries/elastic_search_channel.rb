require 'logger'
require_relative "elastic_search.rb"

module Queries
  class ElasticSearchChannel < ElasticSearch
    def define_query
      type :topic
      @keywordsArray = @keywordsArray.map{ |x| x.length<=3?x:"*#{x}*"}
    end
  end
end
