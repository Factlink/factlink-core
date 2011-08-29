class Users::RegistrationsController < Devise::RegistrationsController
  
  layout "frontend"

  def new    
    @users = User.all[0..10]
    super
  end
  
  def create
    @users = User.all[0..10]
    super
  end
  
end