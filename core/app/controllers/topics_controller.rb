class TopicsController < ApplicationController
  before_filter :load_topic

  def related_user_channels
    authorize! :show, @topic

    top_users = @topic.top_users(5)

    top_channels = top_users.map do |user|
      @topic.channel_for_user(user)
    end

    render json: top_channels
  end

  private
    def load_topic
      @topic  = Topic.by_slug(params[:id])
      @topic || raise_404("Topic not found")
    end
end
