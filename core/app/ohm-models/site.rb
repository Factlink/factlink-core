class Site < OurOhm
  attribute :url
  index :url
  collection :facts, Fact
  #attribute :title
  
  def title
    return "IK BEN EEN TITEL"
  end
  
  def self.find(opts)
    opts = normalize_url(opts)
    super
  end
  
  def self.create(opts)
    opts = normalize_url(opts)
    super
  end
  
  def self.normalize_url(opts)
    opts[:url].sub!(/#(?!\!)[^#]*$/,'') if opts[:url]
    opts
  end
  
end