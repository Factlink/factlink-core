class UsersController < ApplicationController
  layout "accounting"

  def show
    @user = User.where(:username => params[:username]).first
    if @user
      respond_to do |format|
        format.html # show.html.erb
      end
    else
      render :file => "#{Rails.root}/public/404.html", :status => :not_found
    end

  end
end