class ChannelActivitiesController < ApplicationController
  before_filter :load_channel
  before_filter :get_user

  def index
    authorize! :show, @channel

    respond_to do |format|
      format.json do
        @activities = sanitized_activities @channel.activities do |list|
          list.below( params[:timestamp] || 'inf',
            count: params[:number].andand.to_i || 11,
            reversed: true, withscores: true)
        end
        render 'channels/activities'
      end
      format.html { render inline: '', layout: 'channels' }
    end
  end

  def count
    authorize! :see_activities, @user

    timestamp = (params['timestamp'] || 0).to_i

    @number_of_activities = @channel.activities.count_above(timestamp)

    render json: {count: @number_of_activities, timestamp: timestamp }
  end

  def last_fact
    authorize! :show, @channel
    render 'channels/last_fact_activity'
  end

  def create
    authorize! :update, @channel
    activity = Activity[params[:id]] || raise_404
    activity.add_to_list_with_score(@channel.activities)
    render json: {status: :ok}
  end

  def update
    create
  end

  def destroy
    authorize! :update, @channel
    activity = Activity[params[:id]] || raise_404
    activity.remove_from_list(@channel.activities)
    render json: {status: :ok}
  end

  private
    def sanitized_activities(activities, &block)
      retrieved_activities = block.call(activities)
      resulting_activities = []
      retrieved_activities.each do |a|
        if a.andand[:item].andand.valid_for_show?
          resulting_activities << a
        end
      end
      if resulting_activities.length != retrieved_activities.length
        Resque.enqueue(Janitor::CleanActivityList,activities.key.to_s)
      end
      return resulting_activities
    end

    def get_user
      if @channel
        @user ||= @channel.created_by.user
      elsif params[:username]
        @user ||= User.first(conditions: { username: params[:username]}) || raise_404
      end
    end

    def load_channel
      @channel ||= (Channel[params[:channel_id] || params[:id]]) || raise_404('Channel not found')
    end

end
