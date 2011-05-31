class HomeController < ApplicationController

  before_filter :authenticate_user!

  layout "frontend"

  def index
    
    puts "\n\nUser session: \n#{user_session}\n\n"
    
    if params[:search].nil?
      puts "This shouldn't happen. home#index if params[:search].nil?"
      user_input = "#fact"
    else
      user_input = params[:search]
    end

    parser = FactlinkParser.new

    @results = parser.get_results_for_query(user_input)
  end

end