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

  def trimmed_quote max_length
    TrimmedString.new(displaystring).trimmed_quote(max_length)
  end

  def host # Move to site when we have a reference to DeadSite or so
    URI.parse(site_url).host
  end

  def proxy_open_url
    FactlinkUI::Application.config.proxy_url +
        "/?url=" + CGI.escape(site_url) +
        "#factlink-open-" + URI.escape(id)
  end

  def to_hash
    super.merge \
      proxy_open_url: proxy_open_url
  end
end
