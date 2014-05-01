class Avatar
  def initialize user
    @email = user.email
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
