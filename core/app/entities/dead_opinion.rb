DeadOpinion = Struct.new(:believes, :disbelieves, :doubts, :authority) do
  def self.from_opinion(opinion)
    return DeadOpinion.zero unless opinion

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
    authority = self.authority + other.authority
    return DeadOpinion.zero if authority == 0

    believes    = (self.believes*self.authority + other.believes*other.authority)/authority
    disbelieves = (self.disbelieves*self.authority + other.disbelieves*other.authority)/authority
    doubts = (self.doubts*self.authority + other.doubts*other.authority)/authority

    DeadOpinion.new(believes, disbelieves, doubts, authority)
  end

  def net_authority
    authority * (believes-disbelieves)
  end
end
