class Api::UsersController < ApplicationController
  pavlov_action :feed, Interactors::Users::Feed
  pavlov_action :show, Interactors::Users::GetFull

  def update
    render json: interactor(:'users/update', original_username: params[:original_username], fields: params)
  end

  def current
    if current_user
      render json: interactor(:'users/get_full', username: current_user.username)
    else
      render json: interactor(:'users/get_non_signed_in')
    end
  end

  def change_password
    user = Backend::Users.user_by_username(username: params[:username])
    fail('Can currently only update oneself') unless user == current_user

    authorize! :update, user

    user.update_with_password(params[:password]) or fail('Could not update password')
    remembered_sign_in user, bypass: true # http://stackoverflow.com/questions/4264750/devise-logging-out-automatically-after-password-change

    render json: {}
  end
end
