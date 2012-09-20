class IndexForTextSearchCommand
  def initialize object
    @missing_fields = []
    @document = {}
    @object = object

    define_index

    raise 'Index_name is not set.' unless @index_name

    @missing_fields << :id unless field_exists :id

    raise "#{@index_name} missing fields (#{@missing_fields})." unless @missing_fields.count == 0
  end

  def name index_name
    @index_name = index_name
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

  def execute
    options = { body: @document.to_json }

    HTTParty.put "http://#{FactlinkUI::Application.config.elasticsearch_url}/#{@index_name}/#{@object.id}", options
  end
end
