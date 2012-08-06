require 'base64'
require 'gibberish'

class JsLibUrl
  class Builder
    def initialize(opts={})
      @opts = opts
    end
    def new_url username
      JsLibUrl.new username, @opts
    end
    def from_string url
      JsLibUrl.from_string url, @opts[:secret]
    end
  end

  class Username
    def initialize name, secret
      @name = name
      @cipher = Gibberish::AES.new(secret)
    end

    def to_s
      @name
    end

    def encode
      (Base64.encode64(@cipher.enc(@name))).chomp
    end

    def self.decode url, cipher
      cipher.dec(Base64.decode64(url))
    end
  end


  def self.from_string url, secret
    new Username.decode(url.gsub(/^.*\/[^\/]*---([^\/]*)\/$/, '\1'), Gibberish::AES.new(secret))
  end

  def initialize username, opts={}
    @salt = opts[:salt]
    @secret = opts[:secret]
    @username = Username.new username, @secret
    @base_url = opts[:base_url]
  end

  def encoded_username
    @username.encode
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

  def username
    @username.to_s
  end

  def ==(other)
    self.username == other.username
  end
end