class Users::SessionsController < Devise::SessionsController
  
  # layout "accounting"
  layout "client"

  def new
    
    unless params[:layout].nil?
      # Default login
      render "users/sessions/new", :layout => "accounting"
      return false
    else
      # Client login
      render "user_sessions/new"
      return false
    end
    
    super
  end
  
  def create
    super
  end
  
  def destroy
    super
  end
  
end