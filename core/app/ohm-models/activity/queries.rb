class Activity < OurOhm
  module For
    def self.channel(ch)
      ch.activities
    end

    def self.user(gu)
      gu.notifications
    end
  end
end