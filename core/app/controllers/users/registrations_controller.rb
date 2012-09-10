class Users::RegistrationsController < Devise::RegistrationsController
  layout "frontend"

  before_filter :load_user, only: [:edit_password, :update_password]
  before_filter :authenticate_user!

  def create
    build_resource

    # Set random password
    generated_password = Devise.friendly_token

    # Assign field
    resource.email    = params[:user][:email]
    if ( /\A([-a-zA-Z0-9_]+)\Z/.match(params[:user][:registration_code]))
      resource.registration_code    = params[:user][:registration_code]
    end
    resource.password = generated_password

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!

        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource

      the_errors = "Registration failed:<br>"
      resource.errors.each do |key, value|
        the_errors << "#{value.to_s}<br>"
      end

      redirect_to root_path, alert: the_errors.html_safe
    end
  end

  def edit_password
    authorize! :update, @user

    render "users/edit_password"
  end

  def update_password
    authorize! :update, @user

    if @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to user_password_edit_url(@user), notice: 'Your password was successfully updated.'
    else
      render "users/edit_password"
    end
  end

  private
  def load_user
    @user = ::User.first(:conditions => { :username => params[:user_id] }) or raise_404
  end
end
