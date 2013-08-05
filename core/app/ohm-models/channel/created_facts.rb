class Channel < OurOhm
  class CreatedFacts < Channel
    include Channel::GeneratedChannel

    def type
      'created'
    end

    def validate
      self.title = 'Created'
      super
    end

    def topic
      nil
    end

    def contained_channels
      []
    end

  end
end
