class Activity < OurOhm
  module For
    def self.fact(f)
      Query.where([
        {action: [:created, :believe, :disbelieve, :doubt] ,subject: f}
      ])
    end
  end
end
