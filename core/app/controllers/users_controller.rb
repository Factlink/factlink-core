class UsersController < ApplicationController
  layout "accounting"
  
  def show
    
    begin
      @user = User.where(:username => params[:username]).first

    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @user }
    end
  end
end