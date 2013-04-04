class UserFollowersController < ApplicationController
  before_filter :set_user_name
  before_filter :set_follower_user_name, except: :index

  def index
    params[:skip] ||= '0'
    @skip = params[:skip].to_i

    params[:take] ||= '3'
    @take = params[:take].to_i

    @users, @total, @followed_by_me = interactor :'users/followers', @user_name,
      @skip, @take

    render 'users/followers/index', format: 'json'
  end

  def update
    interactor :'users/follow_user', @follower_user_name, @user_name

    return_ok
  end

  def destroy
    interactor :'users/unfollow_user', @follower_user_name, @user_name

    return_ok
  end

  private
  def return_ok
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def set_user_name
    @user_name = params[:username]
  end

  def set_follower_user_name
    @follower_user_name = params[:id]
  end
end
