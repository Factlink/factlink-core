class ConvertSitesToNewNormalization < Mongoid::Migration
  def self.up
    Site.all.ids.each do |id|
      Resque.enqueue NormalizeSiteUrlInteractor, id, :UrlNormalizer
    end
  end

  def self.down
  end
end