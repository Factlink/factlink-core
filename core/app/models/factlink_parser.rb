class FactlinkParser

  FactlinksPerResultPage = 10
  
  def get_results_for_query(user_input)
    parse_tweets_for_query(user_input)
  end
  
  def parse_tweets_for_query(user_input)

    tweets = []
    @results = { 'factlinks' => [], 'topics' => {}, 'users' => [], 'documents' => [] }    

    # Get FactlinksPerResultPage results with hashtag #fact    
    search_query = "#{user_input} #fact"
    search = Twitter::Search.new
    tweets = search.containing(search_query).result_type("recent").per_page(FactlinksPerResultPage)
    
    # Matches to use for @users and #hashtags
    re_users = /@\S+\s/ # TODO: Also filter on end-of-line
    re_hashtags = /#\S+/

    # TODO: Write a nice function
    # Filter each tweet and create Factlink
    hash = {}
    tweets.each do |tweetobject|      
      tweet = tweetobject.text

      # Scan the Tweet for @users and #hashtags to filter
      users = tweet.scan(re_users)
      hashtags = tweet.scan(re_hashtags)
      
      # Filter out the @users
      users.each do |user|
        # puts "\n\nUser: #{user}"
        tweet.gsub!(user, "")
        user.gsub!(/[^0-9a-z]+/i, '')
        user.capitalize!
        @results['users'].push(user)

      end

      # Filter out the #hashtags
      hashtags.each do |hashtag|
        tweet.gsub!(hashtag, "")
        hashtag.gsub!(/[^0-9a-z]+/i, '')
        hashtag.capitalize!
        hash[hashtag] = hash.fetch(hashtag, 0) + 1
      end
      
      # Filter out other useless texts
      tweet.gsub!("RT ", "")
      tweet.gsub!("(via ) ", "")
      
      @results['factlinks'] << Factlink.new(:from_user => tweetobject.from_user, :text => tweet)

    end
    
    @results['users'] = @results['users'].uniq! || []
    
    @results['topics'] = Array(hash) || []
    @results['topics'].delete_if {|topic| topic[0] == "Fact" }
    @results['topics'] = @results['topics'].map.sort_by { |k,v| v }.reverse
    
    @results 
  end # parse_tweets
  

  def get_suggestions_for_searchterm(searchterm)
    # Query Yahoo
    query = "select * from search.suggest where query='#{searchterm}'"
    
    return yql(query)
  end #get_suggestions_for_query
  
  def yql(query)
    uri = "http://query.yahooapis.com/v1/public/yql"

    # everything's requested via POST, which is all I needed when I wrote this
    # likewise, everything coming back is json encoded
    response = Net::HTTP.post_form( URI.parse( uri ), {
      'q' => query,
      'format' => 'json'
    } )

    json = JSON.parse( response.body )
    return json
  end #yql
  
end