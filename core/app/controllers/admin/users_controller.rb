class Admin::UsersController < AdminController
  helper_method :sort_column, :sort_direction

  before_filter :get_activated_users,         only: [:index]
  before_filter :get_reserved_users,          only: [:reserved]
  before_filter :set_available_user_features, only: [:edit, :update]

  load_and_authorize_resource except: [:create]
  before_filter :if_not_found_404, only: [:show, :edit, :update]

  layout "admin"

  def update
    if params[:user][:password] == ''
      params[:user][:password] = nil
      params[:user][:password_confirmation] = nil
    end
    if @user.assign_attributes(params[:user], as: :admin) and @user.save
      @user.features = params[:user][:features].andand.keys
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def approve
    @user.approved = true

    if @user.save validate: false
      render :json => {}, :status => :ok
    else
      render :json => @user.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    username = params[:id]

    interactor = true # TODO Add actual interactor here

    if interactor
      redirect_to admin_users_path, notice: "The account '#{username}' has been deleted."
    else
      redirect_to edit_admin_user_path(@user), alert: 'This account could not be deleted. Did you enter your correct password?'
    end
  end

  private

  def if_not_found_404
    raise_404 unless @user
  end

  def sort_column
    User.fields.collect {|field| field[0] }.include?(params[:sort]) ? params[:sort] : "username"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def get_activated_users
    # TODO eliminate to_sym on the next line. This is a DoS
    @users = User.where(:approved => true).order_by([sort_column.to_sym, sort_direction.to_sym])
  end

  def get_reserved_users
    # TODO eliminate to_sym on the next line. This is a DoS
    @users = User.where(:invitation_token => nil, :approved => false).order_by([sort_column.to_sym, sort_direction.to_sym])
  end

  def set_available_user_features
    @user_features = Ability::FEATURES
    @globally_enabled_features = (interactor :'global_features/all').to_set
  end
end
