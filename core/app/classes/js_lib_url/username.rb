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
      Base64.urlsafe_encode64(self.class.encode(@name)).gsub(/=/,'+') #/ sorry for this, sublime does not highlight correctly
    end

    def self.decode encoded_username, cipher
      new encode(Base64.urlsafe_decode64(encoded_username.gsub(/\+/,'='))), cipher
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