class RenormalizeSitesForNuNl < Mongoid::Migration
  def self.up
    Interactors::NormalizeAllSiteUrls.new.call
  end

  def self.down
  end
end
