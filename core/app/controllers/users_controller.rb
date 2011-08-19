class UsersController < ApplicationController
  # layout "accounting"
  layout "web-frontend-v2"

  before_filter :load_user, 
    :only => [
      :show,
      :activity
      ]

  def show
    @highlight_first_channel = true

    if @user
      respond_to do |format|
        format.html # show.html.erb
      end
    else
      render :file => "#{Rails.root}/public/404.html", :status => :not_found
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