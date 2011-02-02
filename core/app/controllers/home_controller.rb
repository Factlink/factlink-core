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

end
