class Site < OurOhm
  attribute :url
  index :url
  collection :facts, Fact

  def self.find_or_create_by(options)
    find(options.slice [:url]).first || create(options)
  end

  def self.find(options)
    options = normalize_url(options)
    super
  end

  def self.create(options)
    options = normalize_url(options)
    super
  end

  def self.normalize_url(options)
    fail 'url in Site.normalize_url is nil' if options[:url].nil?

    url_normalizer_class = options[:url_normalizer_class] || UrlNormalizer
    url = url_normalizer_class.normalize options[:url]

    options.merge url: url
  end

  def validate
    assert_unique :url
  end
end
