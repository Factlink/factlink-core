class UsersController < ApplicationController
  layout "frontend"

  before_filter :load_user

  def show
    respond_to do |format|
      format.html { redirect_to(channel_path(params[:username], @user.graph_user.stream)) }
      format.json { render json: {:user => Users::User.for(user: @user, view: view_context) }}
    end
  end

  def edit
    authorize! :update, @user
  end

  def update
    authorize! :update, @user

    if @user.update_attributes(params[:user])
      redirect_to edit_user_url(@user.username), notice: 'Your account was successfully updated.'
    else
      render :edit
    end
  end

  def activities
    authorize! :index, Activity

    respond_to do |format|
      format.json { render json: [] }
    end
  end

  def mark_activities_as_read
    authorize! :mark_activities_as_read, @user

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  def load_user
    @user = User.first(:conditions => { :username => (params[:username] or params[:id]) }) or raise_404
  end
end
