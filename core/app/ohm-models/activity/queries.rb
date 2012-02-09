class Activity < OurOhm
  module For
    def self.fact(f)
      Query.where([
        {action: [:created, :believes, :disbelieves, :doubts] ,subject: f}
      ])
    end

    def self.channel(ch)
      Query.where([
        {subject: ch, action: 'added_subchannel'}
      ] +
      ch.facts.map { |f| {object: f, action: [:added_supporting_evidence, :added_weakening_evidence] } }.flatten
      )
    end

    def self.user(gu)
      Query.where(
        gu.channels.map { |ch| {subject: ch, action: 'added_subchannel'}}.flatten
      )
    end
  end
end
