class Avatar
  def self.for_user user
    if user.social_account('facebook').persisted?
      FacebookAvatar.new(user)
    elsif user.social_account('twitter').persisted?
      TwitterAvatar.new(user)
    else
      GravatarAvatar.new(user)
    end
  end

  def initialize user
    @user = user
  end

  def as_json(*args)
    fill_in("<SIZE>")
  end

  def provider
    self.class.name.gsub /Avatar::|Avatar$/, ''
  end

  class TwitterAvatar < Avatar
    def fill_in(size)
      @user.social_account('twitter')
           .omniauth_obj['extra']['raw_info']['profile_image_url_https']
           .sub(/_normal(\.[^.]*)\z/, '_bigger\1')
    end
  end

  class FacebookAvatar < Avatar
    def fill_in(size)
      "https://graph.facebook.com/#{uid}/picture?width=#{size}&height=#{size}"
    end

    def uid
      @user.social_account('facebook').omniauth_obj_id
    end
  end

  class GravatarAvatar < Avatar
    def fill_in(size)
      "https://secure.gravatar.com/avatar/#{hash}?size=#{size}&rating=PG&default=mm"
    end

    def hash
      Digest::MD5.new.update(@user.email.downcase).to_s
    end
  end

end
