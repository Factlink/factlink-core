require 'pavlov'

class UrlBuilder
  include Pavlov::Helpers

  def self.fact_url fact
    self.full_url "facts/#{fact.id}"
  end

  def self.friendly_fact_url fact
    slug = Pavlov.query :"facts/slug", fact, nil
    self.full_url "#{slug}/f/#{fact.id}"
  end

  def self.full_url uri
    URI.join(application_url, uri).to_s
  end

  def self.application_url
    FactlinkUI::Application.config.core_url
  end

end
