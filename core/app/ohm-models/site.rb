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
    return opts if opts[:url].nil?
    url = opts[:url]

    url.gsub! /[<>"]/,
      '<' => '%3C',
      '>' => '%3E',
      '"' => '%22'
    url.gsub! /\s/, '%20'
    url_normalizer_class = opts[:url_normalizer_class] || UrlNormalizer
    url = url_normalizer_class.normalize(url)

    opts.merge url: url
  end

  def validate
    assert_unique :url
  end
end
