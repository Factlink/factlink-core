DeadFact = Struct.new(
  :id,
  :site_url,
  :displaystring,
  :created_at,
  :title,
  :wheel,
  :evidence_count
) do
  def to_s
    displaystring || ""
  end

  def acts_as_class_for_authority
    'Fact'
  end

  def url
    @fact_url ||= FactUrl.new(self)
  end

  def host # Move to site when we have a reference to DeadSite or so
    URI.parse(site_url).host
  end

end
