class Users::ConfirmationsController < Devise::ConfirmationsController

  layout "one_column"

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

  def after_confirmation_path_for(resource_name, resource)
    feed_path
  end
end
