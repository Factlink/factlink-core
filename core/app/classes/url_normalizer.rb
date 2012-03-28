class UrlNormalizer
  def self.normalize url
    url.sub!(/#(?!\!)[^#]*$/,'')
    url
  end
end