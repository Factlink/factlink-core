class UsersController < ApplicationController

  layout "channels"

  before_filter :load_user, 
    :only => [
      :show,
      :activity,
      :facts
      ]

  def show
    if @user
      # @activities = @user.graph_user.activities.sort(:order => "DESC")
      redirect_to(channel_path(params[:username], @user.graph_user.stream.id))
    else
      raise_404
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