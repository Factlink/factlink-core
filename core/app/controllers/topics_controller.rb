class TopicsController < ApplicationController
  def related_user_channels
    authorize! :show, topic
    render_json_channels topic.top_channels(5)
  end

  def top
    render json: top_topics(12)
  end

  def top_channels
    render_json_channels top_topics(12).map {|t| t.top_channels(1).first }
  end

  private
    def topic
      @topic ||= Topic.by_slug(params[:id])
      @topic || raise_404("Topic not found")
    end

    def top_topics(nr)
      Topic.top(nr+2).delete_if {|t| ['created','all'].include? t.slug_title}
    end

    def render_json_channels channels
      json_channels = channels.delete_if {|ch| ch.nil?}.map do |ch|
        Channels::Channel.for(channel: ch,view: view_context)
      end
      render json: json_channels
    end
end
