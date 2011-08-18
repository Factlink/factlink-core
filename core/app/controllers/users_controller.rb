class UsersController < ApplicationController
  # layout "accounting"
  layout "web-frontend-v2"

  def show
    @user = User.where(:username => params[:username]).first
    
    @highlight_first_channel = true
    
    if @user
      respond_to do |format|
        format.html # show.html.erb
      end
    else
      render :file => "#{Rails.root}/public/404.html", :status => :not_found
    end

  end
end