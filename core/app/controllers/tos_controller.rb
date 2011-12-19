class TosController < ApplicationController
  
  before_filter :authenticate_user!
  layout "clean"

  def show
  end
  
  def update
    @user = current_user

    if @user.update_with_password(params[:user])
      redirect_to user_profile_path(@user.username), notice: 'You did it!'
    else
      render action: "show"
    end
  end
  
end
