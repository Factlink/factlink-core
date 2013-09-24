require_relative '../interactors/interactors/channels'

class UsersController < ApplicationController
  layout "frontend"

  before_filter :load_user, except: [:search, :tour_users, :seen_messages]

  def show
    authorize! :show, @user
    backbone_responder do
      render 'users/_user', user: @user
    end
  end

  # TODO: convert this page to backbone
  def edit
    authorize! :access, Ability::FactlinkWebapp
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
        format.html do
          authorize! :access, Ability::FactlinkWebapp
          render :edit
        end
        format.json { render json: { status: :unprocessable_entity } }
      end
    end
  end

  def delete
    password_ok = @user.valid_password? #TODO: move to interactor?

    if password_ok
      interactor(:'users/delete', user_id:@user.id)

      respond_to do |format|
        #TODO: UI, clear session?
        format.html { redirect_to edit_user_url(@user.username), notice: 'Your account was successfully deleted.' }
        format.json { render json: {} }
      end
    else
      respond_to do |format|
        format.html do
          authorize! :access, Ability::FactlinkWebapp
          render :edit #TODO: this is probably wrong; but UI is out of scope here.
        end
        format.json { render json: { status: :unprocessable_entity } }
      end
    end
  end

  def activities
    authorize! :see_activities, @user
    @activities = @user.graph_user.notifications.below('inf', count: 10, reversed: true, withscores: true )

    @activities.select! { |a| a[:item] && a[:item].still_valid? }
    @showing_notifications = true
    respond_to do |format|
      format.json { render 'channels/activities' }
    end
  end

  def notification_settings
    authorize! :edit_settings, @user
    backbone_responder
  end

  def search
    authorize! :index, User
    @users = interactor(:'search_user', keywords: params[:s])
    render :index, formats: [:json]
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

  def seen_messages
    authorize! :update, current_user
    raise HackAttempt unless params[:message] =~ /\A\w+\Z/
    current_user.seen_messages << params[:message]
    render json: {}, status: :ok
  end

  def tour_users
    authorize! :access, Ability::FactlinkWebapp
    # TODO add proper authorization check
    @tour_users = interactor :"users/tour_users"

    render :tour_users, formats: [:json]
  end

  private

  def load_user
    username = params[:username] || params[:id]
    @user = query(:'user_by_username', username: username)
    @user or raise_404
  rescue Pavlov::ValidationError
    raise_404
  end
end
