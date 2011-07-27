class HomeController < ApplicationController

  layout "accounting"

  def index
    @facts = Fact.all
    @users = User.all
  end
end
