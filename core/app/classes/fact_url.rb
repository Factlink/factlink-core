class FactUrl

  def initialize fact
    @fact = fact
  end

  def fact_url
    full_url "facts/#{@fact.id}"
  end

  def friendly_fact_path
    "/f/#{@fact.id}"
  end

  def friendly_fact_url
    full_url friendly_fact_path
  end

  def proxy_open_url
    proxy_url + "/?url=" + CGI.escape(@fact.site_url) +
      "#factlink-open-" + URI.escape(@fact.id)
  end

  def sharing_url
    # Return example.org if testing sharing locally, as Facebook doesn't like our
    # url with port number and such
    return "http://example.org" if ENV['RAILS_ENV'] == 'development'

    proxy_open_url
  end

  private

  def full_url uri
    URI.join(application_url, uri).to_s
  end

  def application_url
    FactlinkUI::Application.config.core_url
  end

  def proxy_url
    FactlinkUI::Application.config.proxy_url
  end

end
