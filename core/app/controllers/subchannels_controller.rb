class SubchannelsController < ApplicationController
  def index
    authorize! :show, channel
    render_subchannels
  end

  def create
    interactor :'channels/add_subchannel', channel_id, subchannel_id
    render_subchannels
  end

  alias :update :create

  def destroy
    interactor :'channels/remove_subchannel', channel_id, subchannel_id
    render_subchannels
  end

  private

    def channel_id
      params[:channel_id]
    end

    def subchannel_id
      params[:subchannel_id]||params[:id]
    end

    def channel
      @channel ||= Channel[channel_id] || raise_404("Channel not found")
    end

    def subchannel
      @subchannel ||= Channel[subchannel_id] || raise_404("Subchannel not found")
    end

    def render_subchannels
      @channels = interactor :'channels/sub_channels', channel
      render 'channels/index', format: 'json', location: channel_path(channel.created_by.user.username, channel.id)
    end
end
