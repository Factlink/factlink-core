class FactlinkSearcher
  
  def search(keyword)
    # result = Sunspot.search(Fact) do
    #   keywords keyword, :fields => [:displaystring]
    # end
    
    result = Fact.search() do
      keywords keyword, :fields => [:displaystring]
      
      # order_by sort_column, sort_direction
      # paginate :page => params[:page], :per_page => per_page
    end
    
    result
  end

  def env
    return RAILS_ENV
  end
  
end



class FactlinkParser

  ResultsLanguage = 'en'
  FactlinksPerResultPage = 10
  FactlinksOn = true
  TwitterOn = true  
  
  def get_results_for_query(user_input)
    
    results = { 'factlinks' => [], 'topics' => {}, 'users' => [], 'documents' => [], 'related_topics' => [], 'spell_check' => [], 'web_results' => {} }
    
    factlink_results = retrieve_factlinks_for_query(user_input)
    twitter_results = parse_tweets_for_query(user_input)
    
    results['factlinks'] = factlink_results['factlinks'] + twitter_results['factlinks']

    results['topics'] = twitter_results['topics']
    results['users'] = twitter_results['users']
    
    # Related topics uses a depricated YQL service.
    # results['related_topics'] = self.get_related_topics_for_search_term(user_input)
    # results['spell_check'] = self.get_spell_check_for_search_term(user_input)
    # results['web_results'] = self.get_web_search_results_for_search_term(user_input)
    
    # YQL keeps breaking Factlink. Let's work with empty results for the moment.
    # TODO: Get a decent API for suggestions and search results
    results['spell_check'] = []
    results['web_results'] = []
    
    return results
  end    
    
    
  def retrieve_factlinks_for_query(user_input)
    
    factlink_results = { 'factlinks' => [], 'topics' => {}, 'users' => [] }

    return factlink_results
  end
  
  
  def parse_tweets_for_query(user_input)  

    twitter_results = { 'factlinks' => [], 'topics' => {}, 'users' => [] }

    # Get FactlinksPerResultPage results with hashtag #fact    
    # search_query = "#{user_input} #fact"
    search_query = "#{user_input}"
    
    search = Twitter::Search.new
    tweets = []
    tweets = search.containing(search_query).result_type('recent').per_page(FactlinksPerResultPage).lang(ResultsLanguage)
    
    # Matches to use for @users and #hashtags
    re_users = /@\S+\s/ # TODO: Also filter on end-of-line
    re_hashtags = /#\S+/

    # TODO: Write a nice function
    # Filter each tweet and create Fact
    hash = {}
    tweets.each do |tweetobject|      
      tweet = tweetobject.text

      # Scan the Tweet for @users and #hashtags to filter
      users = tweet.scan(re_users)
      hashtags = tweet.scan(re_hashtags)
      
      # Filter out the @users
      users.each do |user|
        tweet.gsub!(user, "")
        user.gsub!(/[^0-9a-z]+/i, '')
        user.capitalize!
        twitter_results['users'] << user

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

      twitter_results['factlinks'] << Fact.new(:from_user => tweetobject.from_user, :text => tweet)

    end
    
    twitter_results['users'] = twitter_results['users'].uniq! || []
    
    twitter_results['topics'] = Array(hash) || []
    twitter_results['topics'].delete_if {|topic| topic[0] == "Fact" }
    twitter_results['topics'] = twitter_results['topics'].map.sort_by { |k,v| v }.reverse
    
    twitter_results 
  end # parse_tweets
  
  
  def get_spell_check_for_search_term(search_term)
    # Query Yahoo for spelling
    query = "select * from search.spelling where query='#{search_term}'"
    
    result = yql_results(query)
    if result.nil?
      return []
    else
      result['suggestion']
    end
  end #get_spell_check_for_search_term

  
  def get_related_topics_for_search_term(search_term)
    # Query Yahoo for related topics
    query = "select * from search.suggest where query='#{search_term}'"

    result = yql_results(query)    
    
    if result.nil?
      return []
    else
      result['Result']
    end
  end #get_related_topics_for_search_term
  
  
  def get_web_search_results_for_search_term(search_term)
    # Query Yahoo for web results
    query = "select title, abstract from search.web where query='#{search_term}'"
    #title,clickurl,abstract,dispurl
    
    result = yql_results(query)

    if result.nil?
      return []
    else
      
      cleaned_result = []
      
      ##########
      # Strip HTML tags from the Yahoo results
      result['result'].each do |res|
        title = "#{res['title']}"
        cleaned = title.gsub(/<\/?[^>]*>/, "")        
        cleaned_result << cleaned        
      end

      # return result['result']
      return cleaned_result
    end
  end #get_web_search_results_for_search_term
  
  
  def yql_results(query)
    # TODO: check all values for nil?
    result = yql(query)

    # Return results from Yahoo if any,
    # else nil. Should be checked in calling function!
    if result['query']['count'] > 0
      return result['query']['results']
    else
      return nil
    end
  end
  
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