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
  before_filter :authenticate_user!

  respond_to :json, :html

  def index
    @channels = old_interactor :'channels/visible_of_user_for_user', @user
  end

  def show
    authorize! :show, @channel

    backbone_responder do
      @channel = old_interactor :'channels/get', @channel.id
    end

    mark_channel_as_read if request.format.html?
  end

  #TODO Move to topicscontroller, this searches for topics, not for channels
  def search
    # TODO add access control
    @topics = old_interactor :search_channel, params[:s]
    render 'topics/index', formats: [:json]
  end

  def create
    authorize! :update, @user

    # HACK to ensure the code also acts like it created a channel when the
    # channel already existed. This is needed because sometimes the add_to_channel
    # code in the frontend did not have the list of current channels yet, and tries
    # to create a new channel, while we already have a channel. Since this isn't properly
    # handled in the frontend, the fastest way around it was to act like we created a new
    # channel, but actually return an existing channel.
    title_hash = params[:channel].andand.slice(:title) || params.slice(:title)
    title = title_hash[:title]

    @channels = Channel.find(created_by_id: current_user.graph_user_id)

    # TODO even if we don't fix conceptualla, at least search on the index slug_title here
    @channels.each do |channel|
      @channel = channel if channel.lowercase_title == title.downcase
    end

    unless @channel
      @channel = Channel.new(title_hash)
      @channel.created_by = current_user.graph_user
    end

    if @channel.valid?
      @channel.save

      respond_to do |format|
        format.json do
          @channel = old_interactor :'channels/get', @channel.id
          render 'channels/show'
        end
      end

    else
      respond_to do |format|
        format.json do
          render json: @channel.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    # HACK! SHOULD BE REMOVED!
    # BUG IN SuggestedTopicView, which erroneously saves channels, but that should
    # be the concern of the class that uses it.
    render json: {}
  end

  def destroy
    authorize! :destroy, @channel

    @channel.delete

    respond_to do |format|
      format.html  { redirect_to(channel_activities_path(@user, @user.graph_user.stream), :notice => "#{t(:topic)} successfully deleted") }
      format.json  { render :json => {}, :status => :ok }
    end
  end

  def follow
    old_interactor :'channels/follow', channel_id
    render json: {}, status: :ok
  end

  def unfollow
    old_interactor :'channels/unfollow', channel_id
    render json: {}, status: :ok
  end

  def facts
    authorize! :show, @channel

    from = params[:timestamp].to_i if params[:timestamp]
    count = params[:number].to_i if params[:number]

    @facts = old_interactor :'channels/facts', channel_id, from, count

    mark_channel_as_read

    respond_to do |format|
      format.json { render }
    end
  end

  def add_fact
    fact = Fact[params[:fact_id]]

    old_interactor :"channels/add_fact", fact, @channel

    render nothing: true, status: :no_content
  end

  def create_fact
    authorize! :create, Fact
    authorize! :update, @channel

    @fact = Fact.build_with_data(nil, params[:displaystring].to_s, params[:title].to_s, current_graph_user)

    if @fact.data.save and @fact.save
      mp_track "Factlink: Created"

      old_interactor :"channels/add_fact", @fact, @channel
      @timestamp = Ohm::Model::TimestampedSet.current_time
      render 'channels/fact', formats: [:json]
    else
      render json: @fact.errors, status: :unprocessable_entity
    end
  end

  def remove_fact
    authorize! :update, @channel

    @fact = Fact[params[:fact_id]]

    @channel.remove_fact(@fact)

    render json: {}
  end

  private

  def get_user
    if @channel
      @user ||= @channel.created_by.user
    elsif params[:username]
      @user ||= old_query(:user_by_username, params[:username]) or raise_404
    end
  end

  def load_channel
    @channel ||= Channel[channel_id] || raise_404("#{t(:topic)} not found")
  end

  def channel_id
    params[:channel_id] || params[:id]
  end

  def mark_channel_as_read
    @channel.mark_as_read if @channel.created_by == current_graph_user
  end
end
