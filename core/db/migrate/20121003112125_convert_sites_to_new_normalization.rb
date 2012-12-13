class ConvertSitesToNewNormalization < Mongoid::Migration
  def self.up
    Site.all.ids.each do |id|
      Resque.enqueue Interactors::NormalizeSiteUrl, id, :UrlNormalizer
    end
  end

  def self.down
  end
end
