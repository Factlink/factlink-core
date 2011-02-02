class HomeController < ApplicationController

  def index
    @factlinks = []

    if params[:search].nil?
      puts "This shouldn't happen. home#index if params[:search].nil?"
      user_input = ""
    else
      user_input = params[:search]
    end

    parser = FactlinkParser.new
    @factlinks = parser.parse_tweets_for_query(user_input)

    @factlinks
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
