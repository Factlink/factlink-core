class RemoveFactsWithoutSite < Mongoid::Migration
  def self.up
    Fact.all.to_a
      .keep_if{|f| !f.site || !f.site.url || f.site.url.blank?)}
      .each do |fact|

        Resque.enqueue ReallyRemoveFact, fact.id

    end
  end

  def self.down
  end
end
