class FactlinkParser

  FactlinksPerResultPage = 10
  
  def get_factlinks_for_query(user_input)
    parse_tweets_for_query(user_input)
  end
  
  def parse_tweets_for_query(user_input)

    tweets = []
    @factlinks = { 'factlinks': [], 'topics': [],'users': [], 'documents': [] }

    # Get FactlinksPerResultPage results with hashtag #fact    
    search_query = "#{user_input} #fact"
    search = Twitter::Search.new
    tweets = search.containing(search_query).result_type("recent").per_page(FactlinksPerResultPage)
    
    # Matches to use for @users and #hashtags
    re_users = /@\S+\s/
    re_hashtags = /#\S+/

    # TODO: Write a nice function
    # Filter each tweet and create Factlink
    tweets.each do |tweetobject|      
      tweet = tweetobject.text

      # Scan the Tweet for @users and #hashtags to filter
      users = tweet.scan(re_users)
      hashtags = tweet.scan(re_hashtags)
      
      # Filter out the @users
      users.each do |user|
        tweet.gsub!(user, "")
      end

      # Filter out the #hashtags
      hashtags.each do |hashtag|
        tweet.gsub!(hashtag, "")
      end
      
      # Filter out other useless texts
      tweet.gsub!("RT ", "")
      tweet.gsub!("(via ) ", "")
      
      @factlinks << Factlink.new(:from_user => tweetobject.from_user, :text => tweet)

    end
    
    @factlinks
    
  end # parse_tweets
end