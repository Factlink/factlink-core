class Activity < OurOhm
  module For
    def self.fact(f)
      Query.where([
        {action: [:created, :believe, :disbelieve, :doubt] ,subject: f}
      ])
    end

    def self.channel(ch)
      Query.where([
        {subject: ch}
      ])
    end

    def self.channel(user)
      Query.for user
    end
  end
end
