class Admin::UsersController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :json, :html
  
  layout "admin"
  
  def index
    respond_with(@users)
  end

  def show
    respond_with(@user)
  end

  def new
    respond_with(@user)
  end

  def edit
  end

  def create
    if @user.save
      @user.confirmed_at = DateTime.now
      @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @user.update_with_password(params[:user])
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end
end