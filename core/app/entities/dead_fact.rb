DeadFact = Struct.new(
  :id,
  :site_url,
  :displaystring,
  :created_at,
  :title,
  :votes,
  :deletable?
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

  def trimmed max_length
    TrimmedString.new(displaystring).trimmed(max_length)
  end

  def host # Move to site when we have a reference to DeadSite or so
    return '' unless has_site?

    URI.parse(site_url).host
  end

  def has_site?
    !site_url.blank?
  end

end
