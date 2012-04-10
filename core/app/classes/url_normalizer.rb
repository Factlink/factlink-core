require 'uri'
require 'cgi'

class UrlNormalizer
  def self.normalize url
    url.sub!(/#(?!\!)[^#]*$/,'')

    uri = URI.parse(url)


    uri.query = clean_query(uri.query)
    uri.normalize!

    url = uri.to_s
    url.sub(/\?$/,'')
  end

  def self.clean_query query
    return unless query
    forbidden_uri_params = [:utm_source, :utm_content, :utm_medium, :utm_campaign, ]

    uri_params = CGI.parse(query)
    uri_params = uri_params.delete_if {|k,v| forbidden_uri_params.include? k.to_sym}

    build_query(uri_params)
  end

  def self.build_query(params)
    params.map do |name,values|
      values.map do |value|
        "#{CGI.escape name}=#{CGI.escape value}"
      end
    end.flatten.join("&")
  end
end