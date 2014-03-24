class Api::UsersController < ApplicationController
  pavlov_action :feed, Interactors::Users::Feed
  pavlov_action :show, Interactors::Users::GetFull
  pavlov_action :current, Interactors::Users::GetCurrent

  def update
    render json: interactor(:'users/update', original_username: params[:original_username], fields: params)
  end

  def change_password
    interactor(:'users/change_password', params: params)
    remembered_sign_in current_user, bypass: true # http://stackoverflow.com/questions/4264750/devise-logging-out-automatically-after-password-change

    render json: {}
  end
end
