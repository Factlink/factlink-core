class RemoveFactsWithoutSite < Mongoid::Migration
  def self.up
    Fact.all.ids.each do |fact_id|
      fact = Fact[fact_id]

      unless f.site and f.site.url and not f.site.url.blank?
        Resque.enqueue ReallyRemoveFact, fact_id
      end
    end
  end

  def self.down
  end
end
