DeadOpinion = Struct.new(:b, :d, :u, :a) do
  def self.from_opinion(opinion)
    DeadOpinion.new opinion.b, opinion.d, opinion.u, opinion.a
  end
end
