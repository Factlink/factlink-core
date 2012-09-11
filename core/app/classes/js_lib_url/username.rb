module JsLibUrl
  class Username
    def initialize username
      @name = username
    end

    def to_s
      @name
    end

    def encoded
      Base64.urlsafe_encode64(self.class.encode(@name)).gsub(/=/,'+') #/ sorry for this, sublime does not highlight correctly
    end

    def self.decode encoded_username
      new encode(Base64.urlsafe_decode64(encoded_username.gsub(/\+/,'=')))
    end

    def self.encode string
      encoded = string.reverse
      encoded.tr! "A-Za-z", "N-ZA-Mn-za-m"
    end

    def ==(other)
      self.to_s == other.to_s
    end
  end
end