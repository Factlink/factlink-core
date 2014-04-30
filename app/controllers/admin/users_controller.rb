class Admin::UsersController < AdminController
  helper_method :sort_column, :sort_direction

  before_filter :get_users,                   only: [:index]
  before_filter :set_available_user_features, only: [:edit, :update]

  load_and_authorize_resource except: [:create]
  before_filter :if_not_found_404, only: [:show, :edit, :update]

  layout "admin"

  def update
    if params[:user][:password] == ''
      params[:user][:password] = nil
      params[:user][:password_confirmation] = nil
    end

    @user.features.destroy_all
    params[:user].fetch(:features,{}).keys.each do |feature|
      @user.features << Feature.create!(name: feature)
    end
    @user.save!
    params[:user][:features] = nil

    if @user.assign_attributes(params[:user], as: :admin) and @user.save
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    interactor(:'users/delete', username: @user.username,
                                current_user_password: params[:user][:password]) do |interaction|

      if interaction.valid?
        interaction.call
        redirect_to admin_users_path, notice: "The account '#{@user.username}' has been deleted."
      else
        redirect_to edit_admin_user_path(@user), alert: 'This account could not be deleted. Did you enter your correct password?'
      end
    end
  end

  private

  def if_not_found_404
    fail ActionController::RoutingError.new('') unless @user
  end

  def sort_column
    %w[username email sign_in_count full_name current_sign_in_at].include?(params[:sort]) ? params[:sort] : "username"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_order
    sort_column + " " + sort_direction.upcase
  end

  def get_users
    @users = User.order(sort_order)
  end

  def set_available_user_features
    @user_features = Ability::FEATURES
    @globally_enabled_features = (interactor :'global_features/all').to_set
  end
end
