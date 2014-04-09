class FactUrl

  def initialize dead_fact
    @dead_fact = dead_fact
  end

  def friendly_fact_url
    FactlinkUI::Application.config.core_url + "/f/#{@dead_fact.id}"
  end

  def proxy_open_url
    FactlinkUI::Application.config.proxy_url +
        "/?url=" + CGI.escape(@dead_fact.site_url) +
        "#factlink-open-" + URI.escape(@dead_fact.id)
  end

  def sharing_url
    # Return example.org if testing sharing locally, as Facebook doesn't like our
    # url with port number and such
    return "http://example.org" if Rails.env == 'development'

    proxy_open_url
  end
end
