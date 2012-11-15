class Channel < OurOhm
  class CreatedFacts < Channel
    include Channel::GeneratedChannel

    def type; "created" end

    def add_fields
      self.title = "Created"
    end
    before :validate, :add_fields

    def topic
      nil
    end

    def contained_channels
      []
    end

  end
end
