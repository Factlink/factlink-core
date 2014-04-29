class Users::SessionsController < Devise::SessionsController

  def new
    flash.keep
    redirect_to root_path
  end

  def create
    fail 'Old sign in page -- should never be reached'
  end
end
