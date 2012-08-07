require 'base64'

require_relative './js_lib_url/username.rb'
require_relative './js_lib_url/builder.rb'

class JsLibUrl

  def initialize username, salt, base_url
    @username = username
    @salt = salt
    @base_url = base_url
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
     self.class.prefix(base_url, salt) + encoded_username + self.class.postfix(base_url, salt)
  end

  def self.prefix(base_url, salt)
    "#{base_url}#{salt[0..salt.length/2-1]}"
  end

  def self.postfix(base_url, salt)
    "#{salt[salt.length/2..-1]}/"
  end

  def self.username_from_url url, base_url, salt
    prefix_length = prefix(base_url, salt).length
    postfix_length = postfix(base_url, salt).length
    url[prefix_length..-(1+postfix_length)]
  end

  def username
    @username.to_s
  end

  def ==(other)
    self.username == other.username
  end
end
