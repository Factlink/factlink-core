class ChannelsController < ApplicationController

  layout "channels"

  before_filter :load_channel,
    :only => [
      :show,
      :edit,
      :destroy,
      :update,
      :facts,
      :create_fact,
      :remove_fact,
      :add_fact
    ]
  before_filter :get_user
  before_filter :authenticate_user!

  respond_to :json, :html

  def index
    @channels = interactor :'channels/visible_of_user_for_user', @user
  end

  def backbone_page
    render_backbone_page
  end

  def show
    authorize! :show, @channel
    respond_to do |format|
      format.json do
        @channel = interactor :'channels/get', @channel.id
      end
      format.js
      format.html do
        render_backbone_page
        mark_channel_as_read
      end
    end
  end

  def new
    authorize! :new, Channel
    @channel = Channel.new
  end

  def edit
    authorize! :edit, @channel
  end

  #TODO Move to topicscontroller, this searches for topics, not for channels
  def search
    @topics = interactor :search_channel, params[:s]
    render 'topics/index'
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
        format.html { redirect_to(channel_path(@channel.created_by.user, @channel), :notice => 'Channel successfully created') }
        format.json do
          @channel = interactor :'channels/get', @channel.id
          render 'channels/show'
        end
      end

    else
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => @channel.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :update, @channel

    channel_params = params[:channel] || params

    respond_to do |format|
      if @channel.update_attributes!(channel_params.slice(:title))
        format.html  { redirect_to(channel_path(@channel.created_by.user, @channel),
                      :notice => 'Channel was successfully updated.' )}
        format.json  { render :json => {}, :status => :ok }
      else
        format.html  { render :edit }
        format.json  { render :json => @channel.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @channel

    @channel.delete

    respond_to do |format|
      format.html  { redirect_to(channel_activities_path(@user, @user.graph_user.stream), :notice => 'Channel successfully deleted') }
      format.json  { render :json => {}, :status => :ok }
    end
  end

  def follow
    channel = interactor :'channels/follow', channel_id

    if channel
      render :json => {}, :status => :ok
    else
      render :json => {}, :status => :internal_server_error
    end
  end

  def unfollow
  end

  def facts
    authorize! :show, @channel

    from = params[:timestamp].to_i if params[:timestamp]
    count = params[:number].to_i if params[:number]

    @facts = interactor :'channels/facts', channel_id, from, count

    mark_channel_as_read

    respond_to do |format|
      format.json { render }
    end
  end

  def add_fact
    fact = Fact[params[:fact_id]]

    interactor :"channels/add_fact", fact, @channel

    render nothing: true, :status => :no_content
  end

  def create_fact
    authorize! :create, Fact
    authorize! :update, @channel

    @fact = Fact.build_with_data(nil, params[:displaystring].to_s, params[:title].to_s, current_graph_user)

    if @fact.data.save and @fact.save
      track "Factlink: Created"

      interactor :"channels/add_fact", @fact, @channel
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

    respond_with(@channel)
  end

  private
    def get_user
      if @channel
        @user ||= @channel.created_by.user
      elsif params[:username]
        @user ||= query(:user_by_username, params[:username]) or raise_404
      end
    end

    def load_channel
      @channel ||= Channel[channel_id] || raise_404("Channel not found")
    end

    def channel_id
      params[:channel_id] || params[:id]
    end

    def mark_channel_as_read
      @channel.mark_as_read if @channel.created_by == current_graph_user
    end
end
