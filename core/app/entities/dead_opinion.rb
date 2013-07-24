DeadOpinion = Struct.new(:believes, :disbelieves, :doubts, :authority) do
  def self.zero
    new 0, 0, 1 ,0
  end

  def self.from_hash hash
    new hash[:believes], hash[:disbelieves], hash[:doubts], hash[:authority]
  end

  def to_hash
    {
      believes: believes,
      disbelieves: disbelieves,
      doubts: doubts,
      authority: authority,
    }
  end
end
