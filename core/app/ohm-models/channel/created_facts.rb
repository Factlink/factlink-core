class Channel < OurOhm
  class CreatedFacts < Channel
    def is_real_channel?
      false
    end

    def topic
      nil
    end

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
