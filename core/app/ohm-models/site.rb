class Site < OurOhm
  attribute :url
  index :url
  collection :facts, Fact
  attribute :title
    
  def self.find(opts)
    opts = normalize_url(opts)
    super
  end
  
  def self.create(opts)
    #puts opts
    opts = normalize_url(opts)
    #puts opts
    super
  end
  
  def self.normalize_url(opts)
    opts[:url].sub!(/#(?!\!)[^#]*$/,'') if opts[:url]
    opts
  end
  
end