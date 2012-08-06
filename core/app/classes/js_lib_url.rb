require 'base64'
require 'gibberish'

class JsLibUrl
  class Username
    def initialize username, cipher
      @name = username
      @cipher = cipher
    end

    def to_s
      @name
    end

    def encoded
      Base64.strict_encode64(@cipher.enc(@name))
    end

    def self.decode encoded_username, cipher
      new cipher.dec(Base64.strict_decode64(encoded_username)), cipher
    end

    def ==(other)
      self.to_s == other.to_s
    end
  end

  class Builder
    def initialize(opts={})
      @opts = opts
      @cipher = Gibberish::AES.new(opts[:secret])
    end
    def new_url username
      JsLibUrl.new Username.new(username, @cipher), @opts
    end
    def url_from_string url
      JsLibUrl.new username_from_string(url), @opts
    end

    def username_from_string url
      encoded_username = JsLibUrl.username_from_url(url)
      Username.decode(encoded_username, @cipher)
    end
  end


  def initialize username, opts={}
    @salt = opts[:salt]
    @username = username
    @base_url = opts[:base_url]
  end

  def encoded_username
    @username.encoded
  end

  def base_url
    @base_url
  end

  def salt
    @salt
  end

  def to_s
     "#{base_url}#{salt}---#{encoded_username}/"
  end

  def self.username_from_url url
    url.gsub(/^.*\/[^\/]*---([^\/]*)\/$/, '\1')
  end

  def username
    @username.to_s
  end

  def ==(other)
    self.username == other.username
  end
end