class NormalizeSiteUrl

  def self.perform(*args)
    new(*args).execute
  end

  attr_reader :site_id

  def initialize(site_id:)
    @site_id = site_id
  end

  def execute
    site = ::Site[site_id]

    normalized_url = UrlNormalizer.normalize site.url

    unless save_site_with_new_url(site, normalized_url)
      new_site = ::Site.find_or_create_by url: normalized_url
      move_facts_to_other_site site, new_site
      cleanup_site_if_empty site
    end
  end

  private

  def cleanup_site_if_empty site
    site.delete if site.facts.count == 0
  end

  def save_site_with_new_url site, url
    site.url = url
    site.save
  end

  def move_facts_to_other_site old_site, new_site
    old_site.facts.each do |f|
      f.site = new_site
      f.save
    end
  end
end
