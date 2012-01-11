class Blacklist
  def self.default
    @@default ||= self.new [
      #@TODO: These regexes are just temporary, please fix a nice regex which will match all possible URLS on the given site (also subdomains & https)
      /^http(s)?:\/\/([^\/]+\.)?facebook\.com\//,
      /^http(s)?:\/\/([^\/]+\.)?factlink\.com\//,
      /^http(s)?:\/\/([^\/]+\.)?twitter\.com\//,
      /^http:\/\/localhost[:\/]/,
      /^http(s)?:\/\/([^\/]+\.)?google\.([a-z.]{2,6})\//,
      /^http(s)?:\/\/([^\/]+\.)?gmail\.com\//,
      /^http(s)?:\/\/([^\/]+\.)?irccloud\.com\//,
      /^http(s)?:\/\/([^\/]+\.)?moneybird\.nl\//,
      /^http(s)?:\/\/([^\/]+\.)?github\.com\//,
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