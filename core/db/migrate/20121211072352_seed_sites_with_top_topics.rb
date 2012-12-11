require_relative '../../app/interactors/commands/site/reset_top_topics.rb'

class SeedSitesWithTopTopics < Mongoid::Migration
  def self.up
    Site.all.ids.each do |site_id|
      Resque.enqueue(Commands::Site::ResetTopTopics, site_id.to_i)
    end
  end

  def self.down
  end
end
