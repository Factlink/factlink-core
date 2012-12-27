class TopicsController < ApplicationController
  def related_user_channels
    authorize! :show, topic
    render_json_channels top_channels_for_topic(topic)
  end

  def top
    render json: top_topics(12)
  end

  def top_channels
    render_json_channels get_top_channels
  end

  private
    def get_top_channels
      interactor :'channels/top'
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

    def render_json_channels channels
      json_channels = channels.map do |ch|
        Channels::Channel.for(channel: ch,view: view_context)
      end
      render json: json_channels
    end
end
