class UsersController < ApplicationController
  layout "channels"

  before_filter :load_user

  def show
    respond_to do |format|
      format.html { redirect_to(channel_path(params[:username], @user.graph_user.stream)) }
      format.json { render json: {"user" => Users::User.for(user: @user, view: view_context) }}
    end
  end

  def activities
    respond_to do |format|
      format.json { render json: Activity::For.user(current_user.graph_user).map { |activity| Notifications::Activity.for(activity: activity, view: view_context) }.reverse }
    end
  end

  private
  def load_user
    @user = User.first(:conditions => { :username => params[:username] }) or raise_404
  end
end
