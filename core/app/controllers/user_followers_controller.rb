class UserFollowersController < ApplicationController
  before_filter :set_user_name
  before_filter :set_follower_user_name, except: :index

  def index
    params[:skip] ||= 0
    @skip = params[:skip].to_i

    params[:take] ||= 99999 # 'infinite'
    @take = params[:take].to_i

    @users, @total, @followed_by_me = interactor :'users/followers', @user_name,
      @skip, @take

    render 'users/followers/index', format: 'json'
  end

  def update
    interactor :'users/follow_user', @follower_user_name, @user_name
    mp_track 'User: Followed'
    render json: {}
  end

  def destroy
    interactor :'users/unfollow_user', @follower_user_name, @user_name
    mp_track 'User: Unfollowed'
    render json: {}
  end

  private
  def set_user_name
    @user_name = params[:username]
  end

  def set_follower_user_name
    @follower_user_name = params[:id]
  end
end
