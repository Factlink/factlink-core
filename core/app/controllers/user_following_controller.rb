class UserFollowingController < ApplicationController
  before_filter :set_user_name

  def index
    params[:skip] ||= 0
    @skip = params[:skip].to_i

    params[:take] ||= 99999 # 'infinite'
    @take = params[:take].to_i

    @users, @total = old_interactor :'users/following', @user_name,
      @skip, @take

    render 'users/following/index', format: 'json'
  end

  def update
    following_username = params[:id]
    old_interactor :'users/follow_user', @user_name, following_username
    mp_track 'User: Followed'
    render json: {}
  end

  def destroy
    following_username = params[:id]
    old_interactor :'users/unfollow_user', @user_name, following_username
    mp_track 'User: Unfollowed'
    render json: {}
  end

  private

  def set_user_name
    @user_name = params[:username]
  end
end
