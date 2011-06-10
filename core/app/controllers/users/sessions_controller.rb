class Users::SessionsController < Devise::SessionsController
  
  # layout "accounting"
  layout "client"

  def new
    
    puts "\n\n#{params.to_yaml}"
    
    unless params[:layout].nil?
      puts "\nNo layout given."
      
      render "users/sessions/new", :layout => "accounting"
      return false
    else
      puts "\nLayout given"
      
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