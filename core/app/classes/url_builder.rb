require 'pavlov'

class UrlBuilder

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

  private

  def full_url uri
    URI.join(application_url, uri).to_s
  end

  def application_url
    FactlinkUI::Application.config.core_url
  end

end
