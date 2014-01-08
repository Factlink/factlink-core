class RemoveSiteTopTopics < Mongoid::Migration
  def self.up
    Site.all.ids.each do |site_id|
      redis[site_id][:top_topics].del
    end
  end

  def self.down
  end

  def self.redis
    Nest.new(:site, Redis.current)
  end
end
