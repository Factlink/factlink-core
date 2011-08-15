class HomeController < ApplicationController

  # layout "accounting"
  layout "web-frontend-v2"
  
  def index
    @facts = Fact.all
    @users = User.all[0..10]
  end
end
