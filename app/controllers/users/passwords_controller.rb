class Users::PasswordsController < Devise::PasswordsController
  layout "one_column"

  skip_before_filter :require_no_authentication, only: [:new]
  prepend_before_filter :sign_out_user, except: [:new]

  def new
    self.resource = current_user || super
  end

  private

  def sign_out_user
    sign_out if current_user
    true
  end
end
