class Users::RegistrationsController < Devise::RegistrationsController
  layout "frontend"

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

      error_hash = {}
      resource.errors.each do |attribute, message|
        error_hash[attribute] = resource.errors.full_message(attribute, message)
      end

      render json: error_hash, :status => :unprocessable_entity
    end
  end
end
