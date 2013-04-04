class UserFollowersController < ApplicationController
  before_filter :set_user_id
  before_filter :set_follower_id, except: :index

  def index
    params[:skip] ||= '0'
    @skip = params[:skip].to_i

    params[:take] ||= '3'
    @take = params[:take].to_i

    @users, @total, @followed_by_me = interactor :'users/followers', @user_name,
      @skip, @take

    render 'facts/interactions', format: 'json'
  end

  def update
    interactor :'users/follow_user', @user_name, @follower_id

    return_ok
  end

  def destroy
    interactor :'users/unfollow_user', @user_name, @follower_id

    return_ok
  end

  private
  def return_ok
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def set_user_id
    @user_name = params[:username]
  end

  def set_follower_id
    @follower_id = params[:id]
  end
end
