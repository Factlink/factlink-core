class TosController < ApplicationController
  
  before_filter :authenticate_user!
  layout "clean"

  def show
  end
  
  def update
    @user = current_user
  
    agrees_tos  = (params[:user][:agrees_tos].to_i == 1) ? true : false
    name        = params[:user][:name]

    valid = true
    
    unless agrees_tos
      valid = false
      @user.errors.add("", "You have to accept the Terms of Service to continue.")  
    end
    if name.blank?
      valid = false
      @user.errors.add("", "Please fill in your name to accept the Terms of Service.")  
    end

    if valid and @user.update_with_password(params[:user])
      redirect_to user_profile_path(@user.username), notice: 'You did it!'      
    else
      render action: "show"
    end
  end
  
end
