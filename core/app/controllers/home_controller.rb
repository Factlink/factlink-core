class HomeController < ApplicationController

  def index
    search_query = params[:search]

    @factlinks = Factlink.first
    if search_query
      
      q = /#{search_query}/i
      @factlinks = Factlink.where(:title => q)
    end
    
    puts "\n\nCOUNT: #{@factlinks.count}"
  end

end
