class TopicsController < ApplicationController
  def related_user_channels
    authorize! :show, topic
    @channels = top_channels_for_topic(topic)
    render 'channels/index'
  end

  def top
    render json: top_topics(12)
  end

  def top_channels
    @channels = get_top_channels
    render 'channels/index'
  end

  private
    def get_top_channels
      interactor :'channels/top', 12
    end
    def top_channels_for_topic topic
      interactor :'channels/top_for_topic', topic
    end

    def topic
      @topic ||= Topic.by_slug(params[:id])
      @topic || raise_404("Topic not found")
    end

    def top_topics(nr)
      Topic.top(nr+2).delete_if {|t| t.nil? or ['created','all'].include? t.slug_title}
    end
end
