class UsersController < ApplicationController
  layout "channels"

  before_filter :load_user

  def show
    redirect_to(channel_path(params[:username], @user.graph_user.stream.id))
  end

  private
  def load_user
    @user = User.first(:conditions => { :username => params[:username] }) or raise_404
  end
end