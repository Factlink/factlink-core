module Activities
  class AddedSubchannel < Mustache::Railstache

    def channel_owner
      self[:activity].subject.created_by.user.username
    end

    def channel_owner_profile_url
      channel_path(self[:activity].subject.created_by.user, self[:activity].subject.created_by.stream)
    end

    def channel_title
      self[:activity].subject.title
    end

    def channel_url
      channel_path(self[:activity].subject.created_by.user, self[:activity].subject)
    end

    def icon
      image_tag('activities/icon-channel.png')
    end

  end
end