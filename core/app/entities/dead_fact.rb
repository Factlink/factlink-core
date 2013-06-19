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
    @url_builder || ::UrlBuilder.new(self)
  end
end
