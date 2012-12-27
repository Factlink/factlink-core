class SubchannelsController < ApplicationController
  def index
    authorize! :show, channel
    render_subchannels
  end

  def create
    authorize! :update, channel
    channel.add_channel subchannel
    render_subchannels
  end

  alias :update :create

  def destroy
    authorize! :update, channel
    channel.remove_channel subchannel
    render_subchannels
  end

  private

    def channel
      @channel ||= Channel[params[:channel_id]] || raise_404("Channel not found")
    end

    def subchannel
      @subchannel ||= Channel[params[:subchannel_id]||params[:id]] || raise_404("Subchannel not found")
    end

    def render_subchannels
      render json: retrieve_channels.map {|ch| Channels::Channel.for(channel: ch,view: view_context)},
                   location: channel_path(channel.created_by.user.username, channel.id)
    end

    def retrieve_channels
      interactor :'channels/sub_channels', channel
    end
end
