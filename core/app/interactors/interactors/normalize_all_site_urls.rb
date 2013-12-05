module Interactors
  class NormalizeAllSiteUrls
    include Pavlov::Interactor

    def authorized?
      true # Only migrations should call this
    end

    private

    def execute
      ::Site.all.ids.each do |id|
        Resque.enqueue Interactors::NormalizeSiteUrl, site_id: id,
                                                      normalizer_class_name: :UrlNormalizer
      end
    end
  end
end
