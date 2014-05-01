module Gravatar
  class Template
    def initialize email
      @email = email
    end

    def as_json(*args)
      fill_in("<SIZE>")
    end

    def fill_in(size)
      "https://secure.gravatar.com/avatar/#{hash}?size=#{size}&rating=PG&default=mm"
    end

    def hash
      Digest::MD5.new.update(@email.downcase).to_s
    end
  end

  def self.url(hash:, size:)
    "https://secure.gravatar.com/avatar/#{hash}?size=#{size}&rating=PG&default=mm"
  end

  def self.template_url(email)
    Template.new(email)
  end

  def self.hash(email)
    Digest::MD5.new.update(email.downcase).to_s
  end
end
