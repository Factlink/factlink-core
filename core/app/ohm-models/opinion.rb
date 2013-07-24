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

  def take_values_from_dead_opinion(dead_opinion)
    self.a_r = dead_opinion.authority
    self.b_r = dead_opinion.believes
    self.d_r = dead_opinion.disbelieves
    self.u_r = dead_opinion.doubts
    save
  end
end
