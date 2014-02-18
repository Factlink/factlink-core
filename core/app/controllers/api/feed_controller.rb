# This class returns the feed activities
class Api::FeedController < ApplicationController
  def index
    render json: interactor(:'feed/index', timestamp: params[:timestamp])
  end

  def count
    timestamp = params.fetch(:timestamp, 0).to_i

    @number_of_activities = interactor(:'feed/count', timestamp: timestamp)

    render json: {count: @number_of_activities, timestamp: timestamp }
  end
end
