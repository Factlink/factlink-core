# This controllers manages which channel you follow in your channel
# Since it's now only allowed to follow channels with the same name,
# we use the channels/follow and unfollow interactors.

#TODO Remove this one removing channels

class SubchannelsController < ApplicationController
  def index
    authorize! :show, channel
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
    @channel ||= Channel[channel_id] || raise_404("#{t(:topic)} not found")
  end

  def subchannel
    @subchannel ||= Channel[subchannel_id] || raise_404("#{t(:topic)} not found")
  end

  def render_subchannels
    @channels = interactor(:'channels/sub_channels', channel: channel)
    render 'channels/index', format: 'json', location: channel_path(channel.created_by.user.username, channel.id)
  end
end
