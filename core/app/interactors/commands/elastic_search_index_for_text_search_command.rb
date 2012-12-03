require 'logger'

module Commands
  class ElasticSearchIndexForTextSearchCommand

    def initialize object, options={}
      @missing_fields = []
      @document = {}
      @object = object

      @logger = options[:logger] || Logger.new(STDERR)

      define_index

      raise 'Type_name is not set.' unless @type_name

      @missing_fields << :id unless field_exists :id

      raise "#{@type_name} missing fields (#{@missing_fields})." unless @missing_fields.count == 0
    end

    def execute
      index = ElasticSearch::Index.new @type_name
      index.add @object.id, @document.to_json
      index.refresh # make this operation synchronous
      @logger.info "Adding/updating #{@type_name} to ElasticSearch index."
    end

    private
    def type type_name
      @type_name = type_name
    end

    def field_exists name
      @object.respond_to? name
    end

    def field name
      if field_exists name
        @document[name] = @object.send name
      else
        @missing_fields << name
      end
    end
  end
end
