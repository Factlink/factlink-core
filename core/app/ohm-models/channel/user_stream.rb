class Channel < OurOhm
  class UserStream < Channel
    include Channel::GeneratedChannel

    def type; "stream" end

    def add_fields
      self.title = "All"
    end

    def activities
      created_by.stream_activities
    end

    before :validate, :add_fields

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
