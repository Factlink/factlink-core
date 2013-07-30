class DeadOpinion
  attr_reader :believes, :disbelieves, :doubts, :authority

  def initialize(believes, disbelieves, doubts, authority=0.0)
    @believes    = believes.to_f
    @disbelieves = disbelieves.to_f
    @doubts      = doubts.to_f
    @authority   = authority.to_f
  end

  def self.zero
    for_type(:doubts, 0)
  end

  def self.for_type(type, authority=0)
    case type
    when :believes
      new(1.0, 0.0, 0.0, authority)
    when :disbelieves
      new(0.0, 1.0, 0.0, authority)
    when :doubts
      new(0.0, 0.0, 1.0, authority)
    end
  end

  def self.from_hash hash
    new hash[:believes], hash[:disbelieves], hash[:doubts], hash[:authority]
  end

  def to_h
    {
      believes:    believes,
      disbelieves: disbelieves,
      doubts:      doubts,
      authority:   authority
    }
  end

  def ==(other)
    return false if self.authority != other.authority
    return true if self.authority == 0

    self.believes == other.believes and
      self.disbelieves == other.disbelieves and
      self.doubts == other.doubts
  end

  def self.combine(list)
    believes, disbelieves, doubts, authority = 0, 0, 0, 0

    list.each do |opinion|
      believes    += opinion.authority * opinion.believes
      disbelieves += opinion.authority * opinion.disbelieves
      doubts      += opinion.authority * opinion.doubts
      authority   += opinion.authority
    end

    if authority > 0
      DeadOpinion.new believes   /authority,
                      disbelieves/authority,
                      doubts     /authority,
                      authority
    else
      DeadOpinion.zero
    end
  end

  def +(other)
    self.class.combine([self, other])
  end

  def net_authority
    authority * (believes-disbelieves)
  end
end
