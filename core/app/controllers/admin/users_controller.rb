class Admin::UsersController < AdminController

  before_filter :authenticate_user!
  load_and_authorize_resource

  layout "admin"

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @user.confirmed_at = DateTime.now
    if @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update_with_password(params[:user])
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end
end