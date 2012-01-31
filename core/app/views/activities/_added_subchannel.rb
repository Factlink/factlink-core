module Activities
  class AddedSubchannel < Mustache::Railstache

    def init
      puts self[:activity]
    end

    def action
      self[:activity].action
    end

    def username
      self[:activity].user.user.username
    end

    def user_profile_url
      user_profile_path(self[:activity].user.user)
    end

    def avatar(size=32)
      image_tag(self[:activity].user.user.avatar_url(size: size), :width => size)
    end

    def channel_owner
      self[:activity].subject.created_by.user.username
    end

    def channel_owner_profile_url
      user_profile_path(self[:activity].subject.created_by.user)
    end

    def channel_title
      self[:activity].subject.title
    end

    def channel_url
      channel_path(self[:activity].subject.created_by.user, self[:activity].subject)
    end

    def time_ago
      "#{time_ago_in_words(self[:activity].created_at)} ago"
    end

  end
end