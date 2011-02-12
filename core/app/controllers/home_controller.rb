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


    # http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20search.suggest%20where%20query%3D%22economy%22&format=json&diagnostics=true&callback=result

  end

end
