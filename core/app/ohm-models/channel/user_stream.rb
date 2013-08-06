class Channel < OurOhm
  class UserStream < Channel
    include Channel::GeneratedChannel

    def type
      'stream'
    end

    def activities
      created_by.stream_activities
    end

    def validate
      self.title = 'All'
      super
    end

    def contained_channels
      channels = ChannelList.new(self).channels.to_a
      channels.delete(self)
      return channels
    end

    def topic
      nil
    end

    def inspect
      "UserStream of #{created_by}"
    end

  end
end
