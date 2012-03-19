class Admin::UsersController < AdminController

  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:create]

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
    @user = User.new
    @user.assign_attributes(params[:user], as: :admin)

    @user.confirmed_at = DateTime.now

    authorize! :create, @user
    if @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    if params[:user][:password] == ''
      params[:user][:password] = nil
      params[:user][:password_confirmation] = nil
    end
    if @user.assign_attributes(params[:user], as: :admin) and @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end
end