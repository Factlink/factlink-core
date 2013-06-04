class UserFollowingController < ApplicationController
  before_filter :set_user_name

  def index
    params[:skip] ||= 0
    @skip = params[:skip].to_i

    params[:take] ||= 99999 # 'infinite'
    @take = params[:take].to_i

    @users, @total = interactor :'users/following', @user_name,
      @skip, @take

    render 'users/following/index', format: 'json'
  end

  private
  def set_user_name
    @user_name = params[:username]
  end
end
