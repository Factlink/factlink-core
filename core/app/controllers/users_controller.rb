class UsersController < ApplicationController
  layout "frontend"

  before_filter :load_user, except: [:current]

  def show
    authorize! :show, @user

    backbone_responder do
      full_user = interactor :'users/get_full', username: params[:username]
      render json: full_user
    end
  end

  def current
    user = if current_user
        interactor :'users/get_full', username: current_user.username
      else
        interactor :'users/get_non_signed_in'
      end

    render json: user
  end

  # TODO: convert this page to backbone
  def edit
    authorize! :update, @user
  end

  def update
    authorize! :update, @user

    # sometimes it is passed in user, sometimes it isn't :(
    user_hash =  params[:user] || params

    if @user.update_attributes user_hash
      respond_to do |format|
        format.html { redirect_to edit_user_url(@user.username), notice: 'Your account was successfully updated.' }
        format.json { render json: {} }
      end
    else
      respond_to do |format|
        format.html do
          render :edit
        end
        format.json { render json: { status: :unprocessable_entity } }
      end
    end
  end

  def destroy
    authorize! :destroy, @user

    interactor(:'users/delete', user_id: @user.id,
                                current_user_password: params[:user][:password]) do |delete|

      if delete.valid?
        delete.call
        sign_out
        redirect_to root_path, notice: 'Your account has been deleted.'
      else
        redirect_to edit_user_path(current_user), alert: 'Your account could not be deleted. Did you enter the correct password?'
      end
    end
  end

  def notification_settings
    authorize! :edit_settings, @user

    backbone_responder
  end

  private

  def load_user
    username = params[:username] || params[:id]
    @user = Backend::Users.user_by_username(username: username)
    @user or raise_404
  end
end
