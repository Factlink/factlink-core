DeadOpinion = Struct.new(:b, :d, :u, :a) do
  def self.from_opinion(opinion)
    DeadOpinion.new opinion.b, opinion.d, opinion.u, opinion.a
  end

  def ==(other)
    self.a == other.a and
      self.b == other.b and
      self.d == other.d and
      self.u == other.u
  end

  def self.zero
    DeadOpinion.new(0, 0, 1, 0)
  end

  # inefficient, but allows for quickly changing the + def
  def self.combine(list)
    list.reduce(DeadOpinion.zero, :+)
  end

  def +(other)
    a = self.a + other.a
    return DeadOpinion.zero if a == 0

    b = (self.b*self.a + other.b*other.a)/a
    d = (self.d*self.a + other.d*other.a)/a
    u = (self.u*self.a + other.u*other.a)/a

    DeadOpinion.new(b, d, u, a)
  end
end
