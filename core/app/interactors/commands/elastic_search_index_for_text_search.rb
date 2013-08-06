require_relative '../../classes/elastic_search'

module Commands
  class ElasticSearchIndexForTextSearch
    include Pavlov::Command

    arguments :object

    def execute

      fields.each do |name|
        document[name] = object.send name
      end

      index.add object.id, document.to_json
    end

    private

    def document
      @document ||= {}
    end

    def index
      ElasticSearch::Index.new type_name
    end
  end
end
