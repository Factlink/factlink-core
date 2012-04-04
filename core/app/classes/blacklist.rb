class Blacklist

  def self.domain domain
    regexdomain = domain.gsub /\./, '\\\.'
    r = "https?:\\\/\\\/([^/]*\\\.)?#{regexdomain}\\\/?"
    Regexp.new r
  end

  def self.default
    @@default ||= self.new [
      domain('facebook.com'),
      /^http(s)?:\/\/(?!blog\.factlink\.com)([^\/]+\.)?factlink\.com\/?/,
      domain('twitter.com'),
      domain('gmail.com'),
      domain('irccloud.com'),
      domain('moneybird.nl'),
      domain('flowdock.com'),
      domain('github.com'),
      domain('mixpanel.com'),
      domain('grooveshark.com'),
      /^http:\/\/localhost[:\/]/,
      /^http(s)?:\/\/([^\/]+\.)?google\.([a-z.]{2,6})\//,
    ] + flash + frames
  end

  def self.flash
    [domain('kiprecepten.nl')]
  end

  def self.frames
    [
      domain('insiteproject.com')
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