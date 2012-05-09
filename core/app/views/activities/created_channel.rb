module Activities
  class CreatedChannel < Mustache::Railstache

    def channel_title
      self[:activity].subject.title
    end

    def channel_url
      channel_path(self[:activity].subject.created_by.user, self[:activity].subject)
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
