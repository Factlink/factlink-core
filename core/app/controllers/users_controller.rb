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
    # TODO: This needs to become much more efficient. Now all activities are
    # returned and sliced.
    activities = Activity::For.user(@user.graph_user).sort(order: "DESC").slice(0..6)

    authorize! :index, Activity

    respond_to do |format|
      format.json { render json: activities.map { |activity| Notifications::Activity.for(activity: activity, view: view_context) } }
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

  private
  def load_user
    @user = User.first(:conditions => { :username => (params[:username] or params[:id]) }) or raise_404
  end
end
