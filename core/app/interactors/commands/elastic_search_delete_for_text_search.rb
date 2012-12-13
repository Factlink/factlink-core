require 'logger'

module Commands
  class ElasticSearchDeleteForTextSearch

    def initialize object, options={}
      @missing_fields = []
      @object = object

      @logger = options[:logger] || Logger.new(STDERR)

      define_index

      raise 'Type_name is not set.' unless @type_name

      @missing_fields << :id unless field_exists :id

      raise "#{@type_name} missing fields (#{@missing_fields})." unless @missing_fields.count == 0
    end

    def type type_name
      @type_name = type_name
    end

    def field_exists name
      @object.respond_to? name
    end

    def execute
      HTTParty.delete "http://#{FactlinkUI::Application.config.elasticsearch_url}/#{@type_name}/#{@object.id}"

      # @logger.info "Removing #{@type_name} from ElasticSearch index."
    end

  end
end
