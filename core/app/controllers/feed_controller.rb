# This class returns the feed activities
class FeedController < ApplicationController
  before_filter :get_user

  def index
    authorize! :show, @user
    authorize! :access, Ability::FactlinkWebapp

    backbone_responder do
      render json: interactor(:'feed/index', timestamp: params[:timestamp])
    end
  end

  def count
    authorize! :see_activities, @user

    timestamp = params.fetch(:timestamp, 0).to_i

    @number_of_activities = interactor(:'feed/count', timestamp: timestamp)

    render json: {count: @number_of_activities, timestamp: timestamp }
  end

  def get_user
    @user ||= User.find_by(username: params[:username]) || raise_404
  end
end
