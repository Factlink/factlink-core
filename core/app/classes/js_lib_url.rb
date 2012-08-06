require 'base64'
require 'gibberish'

class JsLibUrl
  class Builder
    def initialize(opts={})
      @opts = opts
      @opts[:cipher] = Gibberish::AES.new(opts[:secret])
    end
    def new_url username
      JsLibUrl.new username, @opts
    end
    def from_string url
      new_url (username_from_string url)
    end

    def username_from_string url
      @opts[:cipher].dec(Base64.decode64(JsLibUrl.username_from_url(url)))
    end

  end


  def initialize username, opts={}
    @salt = opts[:salt]
    @cipher = opts[:cipher]
    @username = username
    @base_url = opts[:base_url]
  end

  def self.username_from_url url
    url.gsub(/^.*\/[^\/]*---([^\/]*)\/$/, '\1')
  end

  def encoded_username
    Base64.encode64(@cipher.enc(@username)).chomp
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