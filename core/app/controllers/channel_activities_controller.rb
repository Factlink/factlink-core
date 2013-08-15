class ChannelActivitiesController < ApplicationController
  before_filter :load_channel, except: [:count]
  before_filter :get_user

  def index
    authorize! :show, @channel

    backbone_responder do
      count = params.fetch(:number) {11}
      @activities = sanitized_activities @channel.activities do |list|
        list.below( params[:timestamp] || 'inf',
          count: count.to_i,
          reversed: true, withscores: true)
      end
      render 'channels/activities'
    end
  end

  def count
    authorize! :see_activities, @user

    timestamp = (params['timestamp'] || 0).to_i

    @number_of_activities = interactor(:'channels/activity_count',
                                          channel_id: channel_id,
                                          timestamp: timestamp)

    render json: {count: @number_of_activities, timestamp: timestamp }
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

    resulting_activities = retrieved_activities.select do |a|
      a[:item] and a[:item].still_valid?
    end

    if resulting_activities.length != retrieved_activities.length
      Resque.enqueue(Commands::Activities::CleanList, list_key: activities.key.to_s)
    end

    resulting_activities
  end

  def get_user
    if @channel
      @user ||= @channel.created_by.user
    elsif params[:username]
      @user ||= User.find_by(username: params[:username]) || raise_404
    end
  end

  def channel_id
    params[:channel_id] || params[:id]
  end

  def load_channel
    @channel ||= Channel[channel_id] || raise_404("#{t(:topic)} not found")
  end
end
