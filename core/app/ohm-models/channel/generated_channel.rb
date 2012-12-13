class Channel < OurOhm
  module GeneratedChannel
    def unread_count
      0
    end

    def editable?
      false
    end

    def inspectable?
      false
    end

    def has_authority?
      false
    end

    def topic
      nil
    end

    def can_be_added_as_subchannel?
      false
    end

  end
end
