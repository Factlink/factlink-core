class JsLibUrl

  class Builder
    def initialize(opts={})
      @opts = opts
      @cipher = Gibberish::AES.new(opts[:secret])
    end
    def url_for username
      ::JsLibUrl.new Username.new(username, @cipher), @opts[:salt], @opts[:base_url]
    end
    def url_from_string url
      ::JsLibUrl.new username_from_string(url), @opts[:salt], @opts[:base_url]
    end

    def username_from_string url
      encoded_username = JsLibUrl.username_from_url(url,@opts[:base_url], @opts[:salt])
      Username.decode(encoded_username, @cipher)
    end
  end
end