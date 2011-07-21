class Site < OurOhm
  attribute :url
  index :url

  set :facts, Fact
  
  def fact_count
    return self.facts.count
  end
  
  def Site.find_or_create_by(url)
    # This feels not so nice, but is the quickest way to get the site
    site = Site.find(:url => url).to_a[0]

    unless site
      site = Site.new(:url => url)
      site.save
    end
    site
  end
end