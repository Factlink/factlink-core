class UrlBuilder

  def self.fact_url fact
    self.full_url "facts/#{fact.id}"
  end

  def self.full_url uri
    URI.join(application_url, uri).to_s
  end

  def self.application_url
    FactlinkUI::Application.config.core_url
  end

end
