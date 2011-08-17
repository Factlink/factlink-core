class HomeController < ApplicationController

  layout "web-frontend-v2"
  
  def index
    @facts = Fact.all.to_a.reverse
    @users = User.all[0..10]
  end
end
