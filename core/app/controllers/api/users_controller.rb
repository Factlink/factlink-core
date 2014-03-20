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
end
