class UsersController < ApplicationController

  layout "frontend"

  before_filter :load_user, 
    :only => [
      :show,
      :activity
      ]

  def show

    if @user      
      @activities = @user.graph_user.activities.sort(:order => "DESC")
      
      puts "\n\nGOT USER\n\n"
      
      respond_to do |format|
        format.html # show.html.erb
      end
    else
      render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false
    end
  end
  
  def activity
    @activities = @user.graph_user.activities.sort(:order => "DESC")
  end
  
  
  private
  def load_user
    @user = User.first(:conditions => { :username => params[:username] })
  end
  
end