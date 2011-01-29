class HomeController < ApplicationController

  def index
    @factlinks = []
    user_input = params[:search]
    results_per_page = 10

    search_query = "#{user_input} #fact"
    
    if search_query      
      search = Twitter::Search.new

      @factlinks = search.containing(search_query).result_type("recent").per_page(results_per_page)      
    end

  end

end
