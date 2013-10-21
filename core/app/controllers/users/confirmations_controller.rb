class Users::ConfirmationsController < Devise::ConfirmationsController

  layout "one_column_simple"

  before_filter :require_no_authentication, :only => :show
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      restore_confirmation_token

      sign_in(resource_name, resource)
      redirect_to after_sign_in_path_for(resource).to_s
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
