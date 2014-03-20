require 'addressable/uri'
require 'ipaddr'

class UrlValidator
  def initialize(url)
    @url = parse(url)
  end

  def valid?
    return false if @url.nil?

    case @url.host
    when /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
      valid_ip?
    else
      valid_hostname?
    end
  end

  def normalized
    fail "invalid url" unless valid?

    @url.user = nil
    @url.password = nil
    @url.normalize.to_s
  end

  private

  # contains all private ranges as described on:
  # http://en.wikipedia.org/wiki/Reserved_IP_addresses
  INVALID_RANGES = [
      "127.0.0.0/8",
      "10.0.0.8/10",
      "100.64.0.0/10",
      "172.16.0.0/12",
      "192.0.0.0/29",
      "192.168.0.0/16",
      "198.18.0.0/15"
    ].map do |s|
      IPAddr.new(s)
    end

  def valid_ip?
    INVALID_RANGES.none? do |range|
      range.include? @url.host
    end
  end

  LOCAL_HOSTNAMES =  Regexp.union([
    /^[^.]*$/,
    /\.$/,
    /\.dev$/
  ])

  def valid_hostname?
    not LOCAL_HOSTNAMES.match(@url.host)
  end

  def parse(url)
    uri = Addressable::URI.parse(url)
    if uri && %w(http https).include?(uri.scheme)
      uri
    else
      nil
    end
  rescue Addressable::URI::InvalidURIError
    nil
  end
end
