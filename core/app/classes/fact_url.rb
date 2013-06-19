require 'pavlov'
require 'cgi'

class FactUrl

  def initialize fact
    @fact = fact
  end

  def fact_url
    full_url "facts/#{@fact.id}"
  end

  def friendly_fact_url
    slug = Pavlov.query :"facts/slug", @fact, nil
    full_url "#{slug}/f/#{@fact.id}"
  end

  def proxy_scroll_url
    return unless @fact.site_url

    proxy_url + "/?url=" + CGI.escape(@fact.site_url) +
      "&scrollto=" + URI.escape(@fact.id)
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
