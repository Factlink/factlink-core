require 'addressable/uri'

module JsLibUrl

  class Builder
    def initialize(opts={})
      @salt = opts[:salt]
      @base_url = opts[:base_url]
    end
    def url_for username
      Url.new Username.new(username), @salt, @base_url
    end
    def url_from_string url
      Url.new username_from_string(url), @salt, @base_url
    end

    def username_from_string url
      encoded_username = Url.username_from_url(url,@base_url, @salt)
      Username.decode(encoded_username)
    end

    def nginx_line
      fake_username = Object.new
      fake_username.class.send(:define_method,:encoded) { 'PLACE_HOLDER_FOR_REGEX' }
      url = Url.new(fake_username, @salt, @base_url).to_s
      path = Addressable::URI.parse(url).path
      regex = Regexp.escape path
      regex.gsub!(/PLACE_HOLDER_FOR_REGEX/ , '[^/]*')
      "location ~ #{regex}(.*)$"
    end
  end
end
