class UserFollowingController < ApplicationController
  def index
    users = interactor(:'users/following', username: params[:username])
    render json: users
  end

  def update
    following_username = params[:id]
    interactor :'users/follow_user', user_to_follow_username: following_username
    render json: {}
  end

  def destroy
    username = params[:username]
    following_username = params[:id]
    interactor :'users/unfollow_user',
               username: username,
               user_to_unfollow_username: following_username
    render json: {}
  end
end
