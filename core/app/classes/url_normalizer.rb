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

  def forbidden_uri_params
    [:utm_source, :utm_content, :utm_medium, :utm_campaign]
  end

  def whitelisted_uri_params
    nil
  end

  def clean_query query
    return unless query

    uri_params = CGI.parse(query)

    forbidden_params = forbidden_uri_params.map {|k| k.to_s }
    if forbidden_params
      uri_params.reject! {|k,v| forbidden_params.include? k}
    end

    allowed_params = whitelisted_uri_params.andand.map {|k| k.to_s }
    if allowed_params
      uri_params.select! {|k,v| allowed_params.include? k}
    end

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
require_relative 'url_normalizer/new_york_times'
require_relative 'url_normalizer/think_progress'
