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
      redirect_to(get_facts_for_channel_path(params[:username], "all"))
    else
      raise ActionController::RoutingError.new('Not Found')
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