class Users::RegistrationsController < Devise::RegistrationsController
  layout "frontend"

  before_filter :load_user, only: [:edit_password, :update_password]
  before_filter :authenticate_user!

  def new
    fail "This page should never render!"
  end

  def create
    build_resource

    resource.email    = params[:user][:email]
    resource.password = Devise.friendly_token # Random password
    resource.generate_username!

    if /\A([-a-zA-Z0-9_]+)\Z/.match(params[:user][:registration_code])
      resource.registration_code = params[:user][:registration_code]
    end

    if resource.valid_full_name_and_email? and resource.save validate: false
      mp_track 'User: Registered account', code: resource.registration_code

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)

        location = after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!

        location = after_inactive_sign_up_path_for(resource)
      end

      if request.format.js?
        render status: 200, json: { status: :ok, location: location }
        return
      else
        respond_with resource, location: location
      end
    else
      clean_up_passwords resource

      the_errors = "Registration failed:<br>"
      error_hash = {}
      resource.errors.each do |attribute, message|
        the_errors << "#{message.to_s}<br>"
        error_hash[attribute] = resource.errors.full_message(attribute, message)
      end

      if request.format.js?
        render json: error_hash, :status => :unprocessable_entity
        return
      else
        redirect_to root_path, alert: the_errors.html_safe
      end

    end
  end

  def edit_password
    authorize! :update, @user

    render "users/edit_password"
  end

  def update_password
    authorize! :update, @user

    if @user.update_with_password(params[:user])
      sign_in @user, bypass: true # http://stackoverflow.com/questions/4264750/devise-logging-out-automatically-after-password-change
      redirect_to user_password_edit_url(@user), notice: 'Your password was successfully updated.'
    else
      render "users/edit_password"
    end
  end

  private

  def load_user
    @user = ::User.find_by(:username => params[:user_id]) or raise_404
  end
end
