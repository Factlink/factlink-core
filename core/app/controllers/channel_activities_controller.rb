# This class returns the feed activities
#
# previously each channel had activities, so this is a
# legacy name, but channels don't have activities anymore
# (at least not ones that are used)
#
class ChannelActivitiesController < ApplicationController
  before_filter :load_channel, except: [:count, :index]
  before_filter :get_user

  def index
    authorize! :show, @user

    backbone_responder do
      count = params.fetch(:number, 11)
      timestamp = params.fetch(:timestamp, 'inf')
      activities = @user.graph_user.stream_activities
      retrieved_activities = activities.below(timestamp,
                                              count: count.to_i,
                                              reversed: true,
                                              withscores: true)

      @activities = sanitized_activities retrieved_activities
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

  private

  def sanitized_activities(retrieved_activities)
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
