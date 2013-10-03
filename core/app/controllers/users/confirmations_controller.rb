class Users::ConfirmationsController < Devise::ConfirmationsController

  layout "one_column_simple"

  before_filter :require_no_authentication, :only => :show
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      if resource.approved?
        sign_in(resource_name, resource)
        redirect_to after_sign_in_path_for(resource).to_s
      else
        respond_with_navigational(resource){ render "awaiting_approval" }
      end
    else
      if params[:confirmation_token]
        @params_token = true
      end
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end

end
