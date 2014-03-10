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
  def self.invalid_ranges
    @invalid_ranges ||= [
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
  end

  def invalid_ranges
    self.class.invalid_ranges
  end

  def valid_ip?
    invalid_ranges.none? do |range|
      range.include? @url.host
    end
  end

  def valid_hostname?
    local_hostnames = [
      /^[^.]*$/,
      /\.$/,
      /\.dev$/
    ]
    local_hostnames.none? do |hostname|
      hostname.match @url.host
    end
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
