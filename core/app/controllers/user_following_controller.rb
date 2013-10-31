class UserFollowingController < ApplicationController
  before_filter :set_user_name

  def index
    @users = interactor(:'users/following', user_name: params[:username])

    render 'users/following/index', format: 'json'
  end

  def update
    following_username = params[:id]
    interactor :'users/follow_user', user_name: @user_name,
                   user_to_follow_user_name: following_username
    mp_track 'User: Followed',
      followed: following_username
    render json: {}
  end

  def destroy
    following_username = params[:id]
    interactor :'users/unfollow_user', user_name: @user_name,
                   user_to_unfollow_user_name: following_username
    mp_track 'User: Unfollowed',
      unfollowed: following_username
    render json: {}
  end

  private

  def set_user_name
    @user_name = params[:username]
  end
end
