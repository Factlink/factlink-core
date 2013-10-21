class Users::ConfirmationsController < Devise::ConfirmationsController

  layout "one_column_simple"

  def show
    self.resource = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])

    if current_user && resource != current_user
      flash[:alert] = 'You are already logged in with another account. Please sign out and try again.'
      flash.keep

      redirect_to after_sign_in_path_for(current_user).to_s
      return
    end

    resource.confirm! if resource.persisted?

    if resource.errors.empty?
      restore_confirmation_token

      unless current_user
        sign_in(resource_name, resource)
      end

      redirect_to after_sign_in_path_for(current_user).to_s
    else
      if params[:confirmation_token]
        @params_token = true
      end
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

  # Users can abort setting up their account, so they need to keep logging in using
  # the confirmation token. To mitigate the associated security problems we set a token
  # timeout using "config.confirm_within" in devise.rb
  # Also depends on User#pending_any_confirmation
  def restore_confirmation_token
    self.resource.confirmation_token = params[:confirmation_token]
    self.resource.save!(validate: false)
  end

  def new
    super

    self.resource = current_user if current_user
  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      flash[:notice] = 'Resent confirmation instructions to your email address.'
      render 'users/confirmations/new'
    else
      respond_with(resource)
    end
  end

end
