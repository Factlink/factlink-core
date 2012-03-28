class UrlNormalizer
  def self.normalize url
    url.sub!(/#(?!\!)[^#]*$/,'')
  end
end