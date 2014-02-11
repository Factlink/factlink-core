class CleanupFactsWithoutInteraction
  @queue = :zzz_janitor

  def self.perform
    Fact.all.ids.each do |fact_id|
      fact = Fact[fact_id]
      fact.delete if fact.deletable?
    end
  end
end
