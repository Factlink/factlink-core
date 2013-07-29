require_relative '../../classes/elastic_search'

module Commands
  class ElasticSearchIndexForTextSearch
    include Pavlov::Command

    arguments :object

    def execute
      define_index

      missing_fields << :id unless field_exists :id

      raise 'Type_name is not set.' unless type_name

      raise "#{type_name} missing fields (#{missing_fields})." unless missing_fields.count == 0

      index.add object.id, document.to_json
    end

    private

    attr_reader :type_name

    def index
      ElasticSearch::Index.new type_name
    end

    def field_exists name
      object.respond_to? name
    end

    def missing_fields
      @missing_fields ||= []
    end

    def document
      @document ||= {}
    end

    # DSL
    def type type_name
      @type_name = type_name
    end

    # DSL
    def field name
      if field_exists name
        document[name] = object.send name
      else
        missing_fields << name
      end
    end
  end
end
