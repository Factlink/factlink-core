class DeadOpinion
  attr_reader :believes, :disbelieves, :doubts, :authority

  def initialize(believes, disbelieves, doubts, authority=0.0)
    @believes = believes.to_f
    @disbelieves = disbelieves.to_f
    @doubts = doubts.to_f
    @authority = authority.to_f
  end

  # TODO: remove when removing Opinion
  def self.from_opinion(opinion)
    return DeadOpinion.zero unless opinion

    DeadOpinion.new opinion.b_r, opinion.d_r, opinion.u_r, opinion.a_r
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

  def value_by_type(type)
    send(type)
  end

  # TODO: fix this for authority=0
  def ==(other)
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
    believes    = weighted_sum_of_type(other, :believes)
    disbelieves = weighted_sum_of_type(other, :disbelieves)
    doubts      = weighted_sum_of_type(other, :doubts)
    authority   = self.authority + other.authority

    DeadOpinion.new(believes, disbelieves, doubts, authority).normalized
  end

  def net_authority
    authority * (believes-disbelieves)
  end

  def normalized
    if authority == 0
      return DeadOpinion.zero
    else
      self
    end
  end

  private

  def weighted_sum_of_type(other, type)
    self_value      = self.value_by_type(type)
    other_value     = other.value_by_type(type)
    total_authority = self.authority + other.authority

    (self_value*self.authority + other_value*other.authority)/total_authority
  end
end
