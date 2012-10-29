class UsersController < ApplicationController
  layout "frontend"

  before_filter :load_user

  def show
    authorize! :show, @user
    respond_to do |format|
      format.html { render layout: 'channels'}
      format.json { render json: Users::User.for(user: @user, view: view_context) }

    end
  end

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
        format.json { render json: {}}
      end
    else
      respond_to do |format|
        format.html { render :edit}
        format.json { render json: { :status => :unprocessable_entity }}
      end
    end
  end

  def activities
    authorize! :see_activities, @user
    @activities = @user.graph_user.notifications.below('inf', count: 10, reversed: true, withscores: true )

    @activities.keep_if { |a| a.andand[:item].andand.valid_for_show? }
    @showing_notifications = true
    respond_to do |format|
      format.json { render 'channels/activities' }
    end
  end

  def mark_activities_as_read
    authorize! :mark_activities_as_read, @user

    @user.last_read_activities_on = DateTime.now

    respond_to do |format|
      if @user.save
        format.json { head :no_content }
      else
        format.json { render json: { :status => :unprocessable_entity } }
      end
    end
  end

  def seen_message
      authorize! :update, @user
      raise HackAttempt unless params[:message] =~ /\A[a-zA-Z_0-9]+\Z/
      @user.seen_messages << params[:message]
      render json: {ok: 'chill'}
  end

  private
  def load_user
    @user = User.first(:conditions => { :username => (params[:username] or params[:id]) }) or raise_404
  end
end
