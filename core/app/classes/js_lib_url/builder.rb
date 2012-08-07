require 'addressable/uri'

class JsLibUrl

  class Builder
    def initialize(opts={})
      @opts = opts
      @base_url = opts[:base_url]
      @cipher = Gibberish::AES.new(opts[:secret])
    end
    def url_for username
      JsLibUrl.new Username.new(username, @cipher), @opts[:salt], @opts[:base_url]
    end
    def url_from_string url
      JsLibUrl.new username_from_string(url), @opts[:salt], @opts[:base_url]
    end

    def username_from_string url
      encoded_username = JsLibUrl.username_from_url(url,@opts[:base_url], @opts[:salt])
      Username.decode(encoded_username, @cipher)
    end

    def nginx_line
      fake_username = Object.new
      fake_username.class.send(:define_method,:encoded) { 'PLACE_HOLDER_FOR_REGEX' }
      url = JsLibUrl.new(fake_username, @opts[:salt], @opts[:base_url]).to_s
      path = Addressable::URI.parse(url).path
      regex = Regexp.escape path
      regex.gsub! /PLACE_HOLDER_FOR_REGEX/ , '.*'
      "location ~ #{regex}(.*)$"
    end
  end
end