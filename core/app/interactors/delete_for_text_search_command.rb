class DeleteForTextSearchCommand

  def initialize object
    @missing_fields = []
    @object = object

    define_index

    raise 'Index_type is not set.' unless @index_type

    @missing_fields << :id unless field_exists :id

    raise "#{@index_type} missing fields (#{@missing_fields})." unless @missing_fields.count == 0
  end

  def type index_type
    @index_type = index_type
  end

  def field_exists name
    @object.respond_to? name
  end

  def execute
    HTTParty.delete "http://#{FactlinkUI::Application.config.elasticsearch_url}/#{@index_type}/#{@object.id}"
  end

end
