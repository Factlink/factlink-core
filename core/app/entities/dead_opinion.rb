DeadOpinion = Struct.new(:believes, :disbelieves, :doubts, :authority) do
  def self.from_opinion(opinion)
    DeadOpinion.new opinion.believes, opinion.disbelieves, opinion.doubts, opinion.authority
  end

  def self.zero
    DeadOpinion.new 0.0, 0.0, 1.0, 0.0
  end

  # TODO: fix this for authority=0
  def ==(other)
    raise 'Can only compare with other DeadOpinion' unless other.class == DeadOpinion

    self.authority == other.authority and
      self.believes == other.believes and
      self.disbelieves == other.disbelieves and
      self.doubts == other.doubts
  end
end
