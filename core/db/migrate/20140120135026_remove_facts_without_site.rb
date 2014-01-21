class RemoveFactsWithoutSite < Mongoid::Migration
  def self.up
    Fact.all.ids.each do |fact_id|
      fact = Fact[fact_id]

      unless fact.site and fact.site.url and not fact.site.url.blank?
        Resque.enqueue ReallyRemoveFact, fact_id
      end
    end
  end

  def self.down
  end
end
