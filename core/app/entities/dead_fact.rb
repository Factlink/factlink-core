DeadFact = Struct.new(
  :id,
  :site_url,
  :displaystring,
  :created_at,
  :title,
  :wheel,
  :evidence_count,
  :proxy_scroll_url,
  :url
) do
  def to_s
    displaystring || ""
  end

  def acts_as_class_for_authority
    'Fact'
  end
end
