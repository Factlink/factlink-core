DeadFact = StrictStruct.new(
  :id,
  :site_url,
  :displaystring,
  :created_at,
  :site_title,
) do

  def to_s
    displaystring || ""
  end

  def url
    @fact_url ||= FactUrl.new(self)
  end

  def trimmed_quote max_length
    TrimmedString.new(displaystring).trimmed_quote(max_length)
  end

  def host # Move to site when we have a reference to DeadSite or so
    URI.parse(site_url).host
  end

  def to_hash
    super.merge \
      url: url.friendly_fact_path,
      proxy_open_url: url.proxy_open_url
  end
end
