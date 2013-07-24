DeadOpinion = Struct.new(:believes, :disbelieves, :doubts, :authority) do
  def self.from_opinion(opinion)
    DeadOpinion.new opinion.believes, opinion.disbelieves, opinion.doubts, opinion.authority
  end

  def self.zero
    DeadOpinion.new 0.0, 0.0, 1.0, 0.0
  end

  def self.for_type(type, authority=0)
    case type
    when :believes
      DeadOpinion.new(1.0, 0.0, 0.0, authority)
    when :disbelieves
      DeadOpinion.new(0.0, 1.0, 0.0, authority)
    when :doubts
      DeadOpinion.new(0.0, 0.0, 1.0, authority)
    end
  end

  # TODO: fix this for authority=0
  def ==(other)
    raise 'Can only compare with other DeadOpinion' unless other.class == DeadOpinion

    self.authority == other.authority and
      self.believes == other.believes and
      self.disbelieves == other.disbelieves and
      self.doubts == other.doubts
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

  def net_authority
    a * (b-d)
  end
end
