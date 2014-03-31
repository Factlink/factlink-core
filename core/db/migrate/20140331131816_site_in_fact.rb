class SiteInFact < Mongoid::Migration
  def self.up
    Fact.all.ids.each do |fact_id|
      fact = Fact[fact_id]
      site_id = fact.key.hget('site_id')
      site_key = Nest.new('Site')[site_id]
      site_url = site_key.hget('url')

      unless site_url.empty?
        fact.data.site_url = site_url
        fact.data.save!

        fact.key.hdel 'site_id'
      end
    end

    Redis.current.del "", *Redis.current.keys("Site:*")
  end

  def self.down
  end
end
