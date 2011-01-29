class HomeController < ApplicationController

  def index
    @factlinks = []
    user_input = params[:search]
    results_per_page = 10

    search_query = "#{user_input} #fact"
    
    tweets = []
    if search_query      
      search = Twitter::Search.new
      tweets = search.containing(search_query).result_type("recent").per_page(results_per_page)      
    end

    # Matches to use
    re_users = /@\S+\s/
    re_hashtags = /#\S+/

    # TODO Write a nice function
    # Filter each tweet and create Factlink
    tweets.each do |tweetobject|
      
      tweet = tweetobject.text
      
      users = tweet.scan(re_users)
      hashtags = tweet.scan(re_hashtags)
      
      users.each do |user|
        tweet.gsub!(user, "")
        # Filter out RT tag as well
        tweet.gsub!("RT ", "")
      end
      
      hashtags.each do |hashtag|
        tweet.gsub!(hashtag, "")
      end
      
      @factlinks << Factlink.new(:from_user => tweetobject.from_user, :text => tweet)
      
    end

    
  end

  # Tweet filtering
  # tweet = "#Fact @baron #TeaParty RT @markknoller WH economic advisor Austan Goolsbee on 3.2% Q4 GDP:a further sign that the economy continues to gain momt."
  # 
  # re_users = /@\S+\s/
  # re_hashtags = /#\S+\s/
  # 
  # users = tweet.scan(re_users)
  # hashtags = tweet.scan(re_hashtags)
  # 
  # users.each do |user|
  #   tweet.gsub!(user, "")
  # end
  # 
  # hashtags.each do |hashtag|
  #   tweet.gsub!(hashtag, "")
  # end

end
