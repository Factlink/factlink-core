class JsLibUrl
  class Username
    def initialize name
      @name = name
    end

    def to_s
      @name
    end

    def encode
      return @name.reverse
    end

    def self.decode name
      new (name.reverse)
    end
  end

  def self.from_string url
    new Username.decode(url.gsub(/^.*\/[^\/]*---([^\/]*)\/$/, '\1')).to_s
  end

  @@salt = 'SUPERSECRET'
  def self.salt= salt
    @@salt = salt
  end

  @@base_url = 'http://invalid.invalid/'

  def self.base_url= base_url
    @@base_url = base_url
  end

  def initialize username
    @username = Username.new username
  end

  def to_s
     "#{@@base_url}/#{@@salt}---#{@username.encode}/"
  end

  def username
    @username.to_s
  end

  def ==(other)
    self.username == other.username
  end
end