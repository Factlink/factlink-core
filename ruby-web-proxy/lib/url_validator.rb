require 'addressable/uri'

class UrlValidator
  def initialize(url)
    begin
      uri = Addressable::URI.parse(url)
      if uri && ['http', 'https'].include?(uri.scheme)
        @url = uri
      else
        @url = nil
      end
    rescue Addressable::URI::InvalidURIError
      @url = nil
    end
  end

  def valid?
    !@url.nil?
  end

  def normalized
    @url.normalize.to_s
  end
end
