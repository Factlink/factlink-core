class UsersController < ApplicationController
  layout "accounting"
  
  def show
    @user = User.where(:username => params[:username]).first
    
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @user }
    end
  end
end