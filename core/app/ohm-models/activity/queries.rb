class Activity < OurOhm
  module For
    def self.fact(f)
      f.interactions
    end

    def self.channel(ch)
      ch.activities
    end

    def self.user(gu)
      gu.notifications
    end
  end
end