class Api::UsersController < ApplicationController
  pavlov_action :feed, Interactors::Users::Feed
  pavlov_action :show, Interactors::Users::GetFull
  pavlov_action :update, Interactors::Users::Update

  def change_password
    user = interactor(:'users/change_password', params: params)
    remembered_sign_in user, bypass: true # http://stackoverflow.com/questions/4264750/devise-logging-out-automatically-after-password-change

    render json: {}
  end

  def destroy
    interactor(:'users/delete', username: params[:username],
                                current_user_password: params[:password])
    sign_out
    render json: {}
  rescue Pavlov::ValidationError => e
    render text: "something went wrong:\n#{e}", status: 400
  end
end
