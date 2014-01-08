class ChannelsController < ApplicationController

  layout "channels"

  before_filter :load_channel,
    :only => [
      :show,
      :destroy,
      :facts,
      :create_fact,
      :remove_fact,
      :add_fact
    ]
  before_filter :get_user
  before_filter :authenticate_user!, except: ['index', 'show']

  respond_to :json, :html

  def index
    @channels = interactor(:'channels/visible_of_user_for_user', user: @user)
  end

  # TODO: Move to topicscontroller, this searches for topics, not for channels
  def search
    # TODO: add access control
    @topics = interactor(:'search_channel', keywords: params[:s])
    render 'topics/index', formats: [:json]
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

  def update
    # HACK! SHOULD BE REMOVED!
    # BUG IN SuggestedTopicView, which erroneously saves channels, but that should
    # be the concern of the class that uses it.
    render json: {}
  end

  def destroy
  end

  def add_fact
    fact = Fact[params[:fact_id]]

    interactor(:'channels/add_fact', fact: fact, channel: @channel)

    render nothing: true, status: :no_content
  end

  def remove_fact
    authorize! :update, @channel

    fact = Fact[params[:fact_id]]

    interactor(:'channels/remove_fact', fact: fact, channel: @channel)

    render json: {}
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
    @channel ||= Channel[channel_id] || raise_404("#{t(:topic)} not found")
  end

  def channel_id
    params[:channel_id] || params[:id]
  end
end
