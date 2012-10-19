require 'logger'
require_relative "elastic_search.rb"

module Queries
  class ElasticSearchUser < ElasticSearch
    def define_query
      type :user
      @keywordsArray = @keywordsArray.map{ |x| "#{x}*"}
    end

    def validate
      raise 'Keywords must not be empty' unless @keywords.length > 0
      raise 'Only one keyword allowed' unless @keywords.split(/\s+/).length == 1
    end
  end
end
