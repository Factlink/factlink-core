class NormalizeSitesWithXssProtection < Mongoid::Migration
  def self.up
    Site.all.ids.each do |id|
      Resque.enqueue(Interactors::NormalizeSiteUrl, site_id: id,
        normalizer_class_name: :UrlNormalizer)
    end
  end

  def self.down
  end
end
