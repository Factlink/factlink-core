require 'pavlov'
require 'cgi'

class FactUrl

  def initialize fact
    @fact = fact
  end

  def fact_url
    full_url "facts/#{@fact.id}"
  end

  def friendly_fact_path
    "/#{slug}/f/#{@fact.id}"
  end

  def friendly_fact_url
    full_url friendly_fact_path
  end

  def proxy_scroll_url
    return unless @fact.site_url

    proxy_url + "/?url=" + CGI.escape(@fact.site_url) +
      "&scrollto=" + URI.escape(@fact.id)
  end

  def sharing_url
    # Return example.org if testing sharing locally, as Facebook doesn't like our
    # url with port number and such
    return "http://example.org/#{slug}" if ENV['RAILS_ENV'] == 'development'

    proxy_scroll_url || friendly_fact_url
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

  def slug
    max_slug_length = 1024
    @fact.to_s.parameterize[0, max_slug_length]
  end

end
