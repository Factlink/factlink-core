class Users::RegistrationsController < Devise::RegistrationsController
  
  layout "web-frontend-v2"

  def new    
    @users = User.all[0..10]
    super
  end
  
  def create
    @users = User.all[0..10]
    super
  end
  
end