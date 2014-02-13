# This class returns the feed activities
class FeedController < ApplicationController
  before_filter :get_user

  def index
    authorize! :show, @user
    authorize! :access, Ability::FactlinkWebapp

    backbone_responder do
      count = params.fetch(:number, 11)
      timestamp = params.fetch(:timestamp, 'inf')
      activities = @user.graph_user.stream_activities
      retrieved_activities = activities.below(timestamp,
                                              count: count.to_i,
                                              reversed: true,
                                              withscores: true)

      @activities = sanitize retrieved_activities, activities.key
      actts = @activities.map do |activity_hash|
        activity = activity_hash[:item]
        subject = activity.subject
        object = activity.object
        action = activity.action
        created_at = activity.created_at
        user =  activity.user.user
        dead_user = Queries::DeadUsersByIds.new(user_ids: [user.id]).call.first

        h = {
          timestamp: activity_hash[:score],
          user: dead_user,
          action: action,
          time_ago: TimeFormatter.as_time_ago(created_at.to_time),
          id: activity.id
        }
        case action
        when "created_comment", "created_sub_comment"
          h[:activity] = {
            fact: query(:'facts/get_dead', id: object.id.to_s)
          }
        when "followed_user"
          subject_user = Queries::DeadUsersByIds.new(user_ids: [subject.user_id]).call.first
          h[:activity] = {
            followed_user: subject_user
          }
        end

        h
      end
      render json: actts
    end
  end

  def count
    authorize! :see_activities, @user

    timestamp = params.fetch(:timestamp, 0).to_i

    @number_of_activities = interactor(:'feed/count', timestamp: timestamp)

    render json: {count: @number_of_activities, timestamp: timestamp }
  end

  private

  def sanitize(retrieved_activities, activities_key)
    resulting_activities = retrieved_activities.select do |a|
      a[:item] and a[:item].still_valid?
    end

    items_filtered = resulting_activities.length != retrieved_activities.length
    clean activities_key if items_filtered

    resulting_activities
  end

  def clean(activities_key)
    Resque.enqueue Commands::Activities::CleanList,
                   list_key: activities_key.to_s
  end

  def get_user
    @user ||= User.find_by(username: params[:username]) || raise_404
  end
end
