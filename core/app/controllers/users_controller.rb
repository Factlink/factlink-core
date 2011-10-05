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
      redirect_to(channels_path)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
  
  def activity
    @activities = @user.graph_user.activities.sort(:order => "DESC")
  end
  
  def facts
    facts = @user.graph_user.stream.facts
    
    respond_to do |format|
      format.html { render :partial => "home/snippets/fact_listing", 
                           :locals => { :facts => facts} }
    end
  end
  
  
  private
  def load_user
    @user = User.first(:conditions => { :username => params[:username] })
  end
  
end