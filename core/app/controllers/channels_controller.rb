class ChannelsController < ApplicationController
  
  before_filter :get_user
  
  def index
  end

  def create
  end

  def new
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
  
  private
  def get_user
    @user = User.first(:conditions => { :username => params[:username]})
  end
  
end





