class Users::ConfirmationsController < Devise::ConfirmationsController

  layout "one_column"

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
      unless current_user
        remembered_sign_in(resource)
      end

      redirect_to after_sign_in_path_for(current_user).to_s
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity) { render :new }
    end
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
