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

  def host # Move to site when we have a reference to DeadSite or so
    URI.parse(site_url).host
  end

  def proxy_open_url
    FactlinkUI::Application.config.proxy_url +
        "/?url=" + CGI.escape(site_url) +
        "#factlink-open-" + URI.escape(id)
  end

  def to_hash
    if FactlinkUI.Kennisland?
      super.merge \
        proxy_open_url: proxy_open_url,
        html_content: html_content
    else
      super.merge \
        proxy_open_url: proxy_open_url
    end
  end

  def html_content
    return nil unless FactlinkUI.Kennisland?

    Sanitize.clean(displaystring, self.class.sanitize_config)
  end

  def self.sanitize_config
    @sanitize_config ||= begin
      extra_config = {
        add_attributes: {
          'a' => { 'rel' => 'nofollow' },
          'iframe' => { 'sandbox' => 'allow-forms allow-scripts' }
        },
        attributes: {
          'iframe' => %w(src allowfullscreen frameborder width height)
        }
      }
      config = Sanitize::Config::RELAXED.deep_merge(extra_config)
      config[:elements] += ['iframe'] # iframes are used in youtube embedding.

      config
    end
  end
end
