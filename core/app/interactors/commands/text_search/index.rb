# TODO add unit test for this class
require_relative '../../../classes/elastic_search'

module Commands
  module TextSearch
    class Index
      include Pavlov::Command

      arguments :object, :type_name, :fields, :fields_changed

      def execute
        return if no_interesting_fields_changed

        index.add object.id, document
      end

      private

      def no_interesting_fields_changed
        return false if fields_changed.nil?
        (fields & fields_changed).empty?
      end

      def document
        fields.each_with_object({}) do |name, doc|
          doc[name] = object.send name
        end
      end

      def index
        ElasticSearch::Index.new type_name
      end
    end
  end
end
