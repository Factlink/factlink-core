require_relative '../../classes/elastic_search'

module Commands
  class ElasticSearchIndexForTextSearch
    include Pavlov::Command

    arguments :object

    def execute
      @missing_fields = []
      @document = {}
      define_index

      @missing_fields << :id unless field_exists :id

      raise 'Type_name is not set.' unless @type_name

      raise "#{@type_name} missing fields (#{@missing_fields})." unless @missing_fields.count == 0

      index = ElasticSearch::Index.new @type_name
      index.add object.id, document.to_json
    end

    private
    def type type_name
      @type_name = type_name
    end

    def field_exists name
      object.respond_to? name
    end

    def field name
      if field_exists name
        @document[name] = object.send name
      else
        @missing_fields << name
      end
    end
  end
end
