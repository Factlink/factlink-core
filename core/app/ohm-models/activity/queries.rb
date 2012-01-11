class Activity < OurOhm
  module For
    def self.fact(f)
      Query.where([{action: :created, subject: f}])
    end
  end
end
