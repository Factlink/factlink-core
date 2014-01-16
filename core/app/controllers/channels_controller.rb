class ChannelsController < ApplicationController

  layout "channels"

  before_filter :load_channel,
    :only => [
      :show,
      :destroy,
      :facts,
      :create_fact,
    ]
  before_filter :get_user
  before_filter :authenticate_user!, except: ['index', 'show']

  respond_to :json, :html

  def index
  end

  def create
    authorize! :update, @user

    title_hash = (params[:channel] || params).slice(:title)
    title = title_hash[:title]

    @channel = Channel.new(title_hash)
    @channel.created_by = current_user.graph_user

    if @channel.valid?
      @channel.save
      render 'channels/show', formats: [:json]
    else
      render json: @channel.errors, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def get_user
    if @channel
      @user ||= @channel.created_by.user
    elsif params[:username]
      @user ||= query(:'user_by_username', username: params[:username])
    end
  end

  def load_channel
    @channel ||= Channel[channel_id] || raise_404("Channel not found")
  end

  def channel_id
    params[:channel_id] || params[:id]
  end
end
