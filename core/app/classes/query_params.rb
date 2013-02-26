class QueryParams
  def initialize url
    @url = url
  end

  def [](param_name)
    original_query[param_name.to_s]
  end

  private
  def original_query
    @original_query ||= Rack::Utils.parse_query parsed_url.query
  end

  def parsed_url
    @parsed_url ||= URI.parse(@url)
  end
end
