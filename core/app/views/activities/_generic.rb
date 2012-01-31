module Activities
  class Generic < Mustache::Railstache

    # user: user,action: action, subject: subject, object: object)

    def username
      self[:activity].user.user.username
    end

    def user_profile_url
      user_profile_path(self[:activity].user.user)
    end

    def avatar(size=32)
      image_tag(self[:activity].user.user.avatar_url(size: size), :width => size)
    end

    def action
      self[:activity].action
    end

    def subject
      puts "+----#{username} #{action}"
      puts self[:activity].subject
      self[:activity].subject.to_s
    end

    def icon
      image_tag('activities/icon-generic.png')
    end

  end
end