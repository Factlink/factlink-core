autoload :Basefact, 'basefact'
autoload :Fact, 'fact'
autoload :FactRelation, 'fact_relation'
autoload :GraphUser, 'graph_user'
autoload :OurOhm, 'our_ohm'
autoload :Site, 'site'

autoload :Opinion, 'opinion'
autoload :Opinionable, 'opinionable'
#autoload :Fact, 'fact'

class Site < OurOhm
  attribute :url
  index :url

  collection :facts, Fact
  
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
    # This feels not so nice, but is the quickest way to get the site
    site = Site.find(:url => url).to_a[0]

    unless site
      site = Site.new(:url => url)
      site.save
    end
    site
  end
end