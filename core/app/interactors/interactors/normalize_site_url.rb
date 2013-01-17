require 'pavlov'

module Interactors
  class NormalizeSiteUrl
    include Pavlov::Interactor

    def initialize site_id, normalizer_class_name
      @site = ::Site[site_id]
      @normalizer_class = Kernel.const_get(normalizer_class_name.to_s)
    end

    def execute
      normalized_url = @normalizer_class.normalize @site.url

      if not save_site_with_new_url(@site, normalized_url)
        new_site = ::Site.find_or_create_by url: normalized_url, url_normalizer_class: @normalizer_class
        move_facts_to_other_site @site, new_site
        cleanup_site_if_empty @site
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
end
