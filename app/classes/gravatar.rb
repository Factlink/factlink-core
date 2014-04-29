module Gravatar
  def self.url(hash:, size:)
    "https://secure.gravatar.com/avatar/#{hash}?size=#{size}&rating=PG&default=mm"
  end

  def self.hash(email)
    Digest::MD5.new.update(email.downcase).to_s
  end
end
