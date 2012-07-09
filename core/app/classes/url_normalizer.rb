require 'addressable/uri'
require 'cgi'

class UrlNormalizer
  @@normalizer_for = Hash.new(UrlNormalizer)

  def self.normalize_for domain
    @@normalizer_for[domain] = self
  end

  def self.normalize url
    url.sub!(/#(?!\!)[^#]*$/,'')

    uri = Addressable::URI.parse(url)

    @@normalizer_for[uri.host].new(uri).normalize
  end

  def initialize uri
    @uri = uri
  end

  def normalize
    uri = @uri

    uri.query = clean_query(uri.query)
    uri.normalize!

    url = uri.to_s
    url.sub(/\?$/,'')
  end

  def clean_query query
    return unless query
    forbidden_uri_params = [:utm_source, :utm_content, :utm_medium, :utm_campaign, ].map {|k| k.to_s }

    uri_params = CGI.parse(query)
    uri_params = uri_params.delete_if {|k,v| forbidden_uri_params.include? k}

    build_query(uri_params)
  end

  def encode_component component
    Addressable::URI.encode_component component
  end

  def build_query(params)
    params.map do |name,values|
      escaped_name = encode_component name
      if values.length > 0
        values.map do |value|
          escaped_value = encode_component value
          "#{escaped_name}=#{escaped_value}"
        end
      else
        ["#{escaped_name}"]
      end
    end.flatten.join("&")
  end
end

require_relative 'url_normalizer/proxy'
