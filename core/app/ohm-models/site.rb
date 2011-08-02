class Site < OurOhm
  attribute :url
  index :url

  collection :facts, Fact
  
  def validate
    #assert_url :url
  end
  
  # More Rails like behaviour:
  def Site.first
    return Site.all.first
  end
  def Site.last
    case Site.all.count
    when 0
      return nil
    when 1
      return Site.first
    else
      return Site.all.to_a[Site.all.count - 1]
    end
  end


  def fact_count
    return self.facts.count
  end
  
  def Site.find_or_create_by(url)

    site = Site.find(:url => url).first

    unless site
      site = Site.new(:url => url)
      site.save
    end
    site
  end
end