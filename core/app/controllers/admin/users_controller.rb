class Admin::UsersController < AdminController
  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!
  before_filter :get_activated_users,         only: [:index]
  before_filter :get_reserved_users,          only: [:reserved]
  before_filter :set_available_user_features, only: [:new, :create, :edit, :update]

  load_and_authorize_resource :except => [:create]

  layout "admin"


  def create
    @user = User.new
    @user.assign_attributes(params[:user], as: :admin)

    @user.confirmed_at = DateTime.now

    authorize! :create, @user
    if @user.save
      redirect_to admin_user_path, notice: 'User was successfully created.'
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

  private

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
  end
end
