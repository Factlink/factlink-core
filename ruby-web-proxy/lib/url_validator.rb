require 'addressable/uri'

class UrlValidator
  def initialize(url)
    @url = nil
  end

  def valid?
    !@url.nil?
  end

  def normalized
    @url.normalize.to_s
  end

  private

  def parse(url)
    uri = Addressable::URI.parse(url)
    if uri && %w(http https).include?(uri.scheme)
      @url = uri
    else
      nil
    end
  rescue Addressable::URI::InvalidURIError
    nil
  end
end
