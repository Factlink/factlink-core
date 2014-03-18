module Backend
  module Sites
    extend self

    def normalize_all_urls
      ::Site.all.ids.each do |id|
        Resque.enqueue NormalizeSiteUrl,
          site_id: id,
          normalizer_class_name: :UrlNormalizer
      end
    end
  end
end
