class Blacklist

  def self.domain domain
    regexdomain = domain.gsub /\./, '\\\.'
    r = "https?:\\\/\\\/([^/]*\\\.)?#{regexdomain}\\\/?"
    Regexp.new r
  end

  def self.strict_domain domain
    regexdomain = domain.gsub /\./, '\\\.'
    r = "https?:\\\/\\\/#{regexdomain}\\\/?"
    Regexp.new r
  end

  def self.default
    @@default ||= self.new [
      domain('facebook.com'),
      /^http(s)?:\/\/(?!blog\.factlink\.com)([^\/]+\.)?factlink\.com\/?/,
      domain('fct.li'),
      domain('icloud.com'),
      domain('twitter.com'),
      domain('gmail.com'),
      domain('irccloud.com'),
      domain('kickoffapp.com'),
      domain('moneybird.nl'),
      domain('newrelic.com'),
      domain('flowdock.com'),
      domain('yammer.com'),
      strict_domain('github.com'),
      strict_domain('www.github.com'),
      domain('mixpanel.com'),
      domain('grooveshark.com'),
      /^http:\/\/localhost[:\/]/,
      strict_domain('google.([a-z.]{2,6})'),
      strict_domain('www.google.([a-z.]{2,6})')

    ] + flash + frames + weird_bugs
  end

  def self.flash
    [domain('kiprecepten.nl')]
  end

  def self.frames
    [
      domain('insiteproject.com')
    ]
  end

  def self.weird_bugs
    [
      # breaks jquery:
      domain('avc.com'),

      #annotating does not work
      domain('smashingmagazine.com')
    ]
  end

  def initialize(blacklist)
    @blacklist = blacklist
  end

  def matches?(str)
    @blacklist.each do |regex|
      if regex.match(str)
        return true
      end
    end

    false
  end

end
