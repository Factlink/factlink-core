class Blacklist
  def self.default
    @@default ||= self.new [
      #@TODO: These regexes are just temporary, please fix a nice regex which will match all possible URLS on the given site (also subdomains & https)
      /^http(s)?:\/\/([^\/]+\.)?facebook\.com/,
      /^http(s)?:\/\/([^\/]+\.)?factlink\.com/,
      /^http(s)?:\/\/([^\/]+\.)?google\.com/,
      /^http(s)?:\/\/([^\/]+\.)?gmail\.com/,
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