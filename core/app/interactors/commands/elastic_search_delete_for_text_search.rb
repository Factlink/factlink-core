require 'logger'

module Commands
  class ElasticSearchDeleteForTextSearch
    # TODO: Rewrite this command to be fully compatible with Pavlov

    def initialize object, options={}
      @object = object
    end

    def type type_name
      @type_name = type_name
    end

    def call
      execute
    end

    def execute
      raise 'Type_name is not set.' unless @type_name
      HTTParty.delete "http://#{FactlinkUI::Application.config.elasticsearch_url}/#{@type_name}/#{@object.id}"
    end
  end
end
