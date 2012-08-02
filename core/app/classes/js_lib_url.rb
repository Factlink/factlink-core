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
    new Username.decode(url.gsub(/^.*\/([^\/]*)\/$/, '\1')).to_s
  end

  def initialize username
    @username = Username.new username
  end

  def to_s
     "http://foobar.com/#{@username.encode}/"
  end

  def username
    @username.to_s
  end

  def ==(other)
    self.username == other.username
  end
end