module Commands
  class ElasticSearchDeleteForTextSearch
    include Pavlov::Command
    arguments :object

    def execute
      raise 'Type_name is not set.' unless @type_name
      HTTParty.delete "http://#{FactlinkUI::Application.config.elasticsearch_url}/#{@type_name}/#{@object.id}"
    end
  end
end
