class Channel < OurOhm
  class UserStream < Channel
    def is_real_channel?
      false
    end

    def topic
      nil
    end

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
