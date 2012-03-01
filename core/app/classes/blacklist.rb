class Blacklist

  def self.domain domain
    regexdomain = domain.gsub /\./, '\\\.'
    r = "https?:\\\/\\\/([^/]*\\\.)?#{regexdomain}\\\/"
    Regexp.new r
  end

  def self.default
    @@default ||= self.new [
      domain('facebook.com'),
      domain('factlink.com'),
      domain('twitter.com'),
      domain('gmail.com'),
      domain('irccloud.com'),
      domain('moneybird.nl'),
      domain('github.com'),
      domain('mixpanel.com'),
      /^http:\/\/localhost[:\/]/,
      /^http(s)?:\/\/([^\/]+\.)?google\.([a-z.]{2,6})\//,
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