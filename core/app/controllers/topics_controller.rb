class TopicsController < ApplicationController
  before_filter :load_topic

  def related_users
     authorize! :show, @topic

     render layout: false, partial: "channels/related_users",
       locals: {
            related_users: @topic.top_users.below('inf', count: 5).map {|gu| gu.user },
            topic: @topic,
            excluded_users: []
       }
  end

  private
    def load_topic
      @topic  = Topic.by_slug(params[:id])
      @topic || raise_404("Topic not found")
    end
end
