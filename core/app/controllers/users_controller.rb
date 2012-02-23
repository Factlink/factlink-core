class UsersController < ApplicationController
  layout "channels"

  before_filter :load_user

  def show
    respond_to do |format|
      format.html { redirect_to(channel_path(params[:username], @user.graph_user.stream)) }
      format.json { render json: {:user => Users::User.for(user: @user, view: view_context) }}
    end
  end

  def activities
    authorize! :index, Activity

    respond_to do |format|
      format.json { render json: [] }
    end
  end

  def mark_activities_as_read
    authorize! :mark_activities_as_read, @user

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  def load_user
    @user = User.first(:conditions => { :username => params[:username] }) or raise_404
  end
end
