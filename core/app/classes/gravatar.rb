module Gravatar
  # from: http://douglasfshearer.com/blog/gravatar-for-ruby-and-ruby-on-rails
  # Returns a Gravatar URL associated with the email parameter.
  #
  # Gravatar Options:
  # - rating: Can be one of G, PG, R or X. Default is X.
  # - size: Size of the image. Default is 80px.
  # - default: URL for fallback image if none is found or image exceeds rating.
  def gravatar_url(email,gravatar_options={})
    grav_url = 'https://secure.gravatar.com/avatar/'
    grav_url << gravatar_hash(email) << "?"
    grav_url << (gravatar_options.slice(:rating,:size,:default).map{|k,v| "#{k}=#{v}"}.join "&")
    grav_url
  end

  def gravatar_hash(email)
    "#{Digest::MD5.new.update(email.downcase)}"
  end
end