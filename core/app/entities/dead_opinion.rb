DeadOpinion = Struct.new(:b, :d, :u, :a) do
  def self.from_opinion(opinion)
    DeadOpinion.new opinion.b, opinion.d, opinion.u, opinion.a
  end

  # TODO: fix this for authority=0
  def ==(other)
    self.a == other.a and
      self.b == other.b and
      self.d == other.d and
      self.u == other.u
  end
end
