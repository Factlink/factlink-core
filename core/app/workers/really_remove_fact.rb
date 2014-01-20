class ReallyRemoveFact
  @queue = :zzz_janitor

  def self.perform fact_id
    Fact[fact_id].delete
  end
end
