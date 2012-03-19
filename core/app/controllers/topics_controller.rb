class TopicsController < ApplicationController
  before_filter :load_topic

  def related_users
     authorize! :show, @channel

     render layout: false, partial: "channels/related_users",
       locals: {
            related_users: GraphUser.all,
            topic: @topic,
            excluded_users: [@channel.created_by]
       }
  end

  private
    def load_topic
      @topic  = Topic.by_slug(params[:id])
      @topic || raise_404("Topic not found")
    end
end
