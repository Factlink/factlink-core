class UserFollowingController < ApplicationController
  def index
    @users = interactor(:'users/following', user_name: params[:username])
    # TODO: this is unnecessarily inefficient: we're getting a list of full users we're
    # following when in fact the backbone model only cares about the list of usernames.
    render 'users/following/index', format: 'json'
  end

  def update
    user_name = params[:username]
    following_username = params[:id]
    interactor :'users/follow_user',
               user_name: user_name,
               user_to_follow_user_name: following_username
    mp_track 'User: Followed',
      followed: following_username
    render json: {}
  end

  def destroy
    user_name = params[:username]
    following_username = params[:id]
    interactor :'users/unfollow_user',
               user_name: user_name,
               user_to_unfollow_user_name: following_username
    mp_track 'User: Unfollowed',
      unfollowed: following_username
    render json: {}
  end
end
