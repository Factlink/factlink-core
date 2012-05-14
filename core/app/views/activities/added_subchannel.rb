module Activities
  class AddedSubchannel < Mustache::Railstache

    def channel_owner
      if self[:activity].subject.created_by.user == current_user
        "your"
      else
        "#{self[:activity].subject.created_by.user.username}'s"
      end

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

    def to_channel_title
      self[:activity].object.title
    end

    def to_channel_url
      channel_path(self[:activity].object.created_by.user, self[:activity].object)
    end

    def icon
      image_tag('activities/icon-channel.png')
    end

    def channel_definition
      t(:channel)
    end

    def channels_definition
      t(:channels)
    end
  end
end
