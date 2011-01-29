class HomeController < ApplicationController

  def index
    search_query = params[:search]
    

    @factlinks = []

    if search_query      
      q = /#{search_query}/i
      @factlinks = Factlink.where(:title => q)
    end
  end

end
