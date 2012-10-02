class Site < OurOhm
  attribute :url
  index :url
  collection :facts, Fact

  def self.find_or_create_by(opts)
    self.find(opts.slice [:url]).first || self.create(opts)
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
    opts[:url] = UrlNormalizer.normalize(opts[:url]) if opts[:url]
    opts
  end

end