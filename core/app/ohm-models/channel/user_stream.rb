class Channel < OurOhm
  class UserStream < Channel
    include Channel::GeneratedChannel

    def type
      'stream'
    end

    def validate
      self.title = 'All'
      super
    end

    def contained_channels
      []
    end

    def topic
      nil
    end

    def inspect
      "UserStream of #{created_by}"
    end

  end
end
