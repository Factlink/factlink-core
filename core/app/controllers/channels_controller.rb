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
      :activities,
      :remove_fact,
      :toggle_fact,
      :remove_fact,
      :follow,
      :last_fact_activity
    ]

  before_filter :get_user

  respond_to :json, :html

  before_filter :authenticate_user!


  def index
    authorize! :index, Channel

    respond_to do |format|
      format.json { render :json => channels_for_user(@user).map {|ch| Channels::Channel.for(channel: ch,view: view_context,channel_user: @user)} }
    end
  end

  def backbone_page
    render_backbone_page
  end

  def show
    authorize! :show, @channel
    respond_to do |format|
      format.json { render :json => Channels::Channel.for(channel: @channel,view: view_context,channel_user: @user)}
      format.js
      format.html do
        render inline:'', layout: "channels"
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

  def search
    interactor = SearchChannelInteractor.new params[:s].to_s, @user, ability: current_ability
    @topics = interactor.execute
    render 'topics/index'
  end

  def create
    authorize! :update, @user

    @channel = Channel.new(params[:channel].andand.slice(:title) || params.slice(:title))
    @channel.created_by = current_user.graph_user

    # Check if object valid, then execute:
    if @channel.valid?
      @channel.save

      unless params[:for_fact].nil?
        @fact = Fact[params[:for_fact]]
        @channel.add_fact(@fact)
      end

      unless params[:for_channel].nil?
        @subchannel = Channel[params[:for_channel]]
        @channel.add_channel(@subchannel)
      end

      respond_to do |format|
        format.html { redirect_to(channel_path(@channel.created_by.user, @channel), :notice => 'Channel successfully created') }
        format.json { render :json => Channels::Channel.for(channel: @channel,view: view_context)}
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

  def facts
    authorize! :show, @channel
    @facts = @channel.facts(from: params[:timestamp], count: params[:number] || 7, withscores: true)

    mark_channel_as_read

    respond_to do |format|
      format.json { render json: @facts.map {|fact| Facts::Fact.for(fact: fact[:item],view: view_context,channel: @channel,timestamp: fact[:score])} }
    end
  end

  # DEPRECATE i think this can be thrown away now,
  #           since the last user was (I think) the jslib -- mark
  def toggle_fact
    authorize! :update, @channel

    @fact = Fact[params[:fact_id]]

    if @channel.facts.include?(@fact)
      @channel.remove_fact(@fact)
    else
      @channel.add_fact(@fact)
    end
    render nothing: true
  end

  def add_fact
    interactor = AddFactToChannelInteractor.new params[:fact_id], params[:id], ability: current_ability
    interactor.execute

    render nothing: true, :status => :no_content
  end

  def create_fact
    authorize! :create, Fact
    authorize! :update, @channel

    @fact = Fact.build_with_data(nil, params[:displaystring].to_s, params[:title].to_s, current_graph_user)

    if @fact.data.save and @fact.save
      track "Factlink: Created"

      @channel.add_fact(@fact)
      render json: Facts::Fact.for(fact: @fact, channel: @channel, timestamp: Ohm::Model::TimestampedSet.current_time, view: view_context)
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
      @channel ||= (Channel[params[:channel_id] || params[:id]]) || raise_404("Channel not found")
    end

    def mark_channel_as_read
      @channel.mark_as_read if @channel.created_by == current_graph_user
    end

    def channels_for_user(user)
      @channels = user.graph_user.channels
      @channels = @channels.keep_if { |ch| ch.type == 'channel' }
      unless @user == current_user
        @channels = @channels.keep_if {|ch| ch.sorted_cached_facts.count > 0 }
      end
      @channels
    end
end
