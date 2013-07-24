class Opinion < OurOhm
  # naming conventions as in the document describing the calculations
  # b = belief
  # d = disbeliefs
  # u = uncertain
  #
  # a = authority
  #
  # _r in redis

  attribute :b_r
  attribute :d_r
  attribute :u_r
  attribute :a_r

  def b
    self.b_r.to_f
  end

  def d
    self.d_r.to_f
  end

  def u
    self.u_r.to_f
  end

  def a
    self.a_r.to_f
  end

  alias :b= :b_r=
  alias :d= :d_r=
  alias :u= :u_r=
  alias :a= :a_r=

  def take_values_from_dead_opinion(dead_opinion)
    self.a = dead_opinion.authority
    self.b = dead_opinion.believes
    self.d = dead_opinion.disbelieves
    self.u = dead_opinion.doubts
    save
  end
end
