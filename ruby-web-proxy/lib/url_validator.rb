require 'addressable/uri'

class UrlValidator
  def initialize(url)
    @url = nil

    begin
      uri = Addressable::URI.parse(url)
      if uri && %w(http https).include?(uri.scheme)
        @url = uri
      end
    rescue Addressable::URI::InvalidURIError
    end
  end

  def valid?
    !@url.nil?
  end

  def normalized
    @url.normalize.to_s
  end
end
