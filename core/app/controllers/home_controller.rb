class HomeController < ApplicationController

  # layout "accounting"
  layout "web-frontend-v2"
  
  def index
    @facts = Fact.all
    @users = User.all
  end
end
