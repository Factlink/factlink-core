class HomeController < ApplicationController

  def index

    @results = { 'factlinks' => [], 'topics' => [] }
  
    if params[:search].nil?
      puts "This shouldn't happen. home#index if params[:search].nil?"
      user_input = ""
    else
      user_input = params[:search]
    end

    parser = FactlinkParser.new
    @results = parser.get_results_for_query(user_input)

  end

end
