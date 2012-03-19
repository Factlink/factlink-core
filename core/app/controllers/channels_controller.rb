class ChannelsController < ApplicationController

  layout "channels"

  before_filter :get_user

  respond_to :json, :html

  before_filter :load_channel,
    :only => [
      :show,
      :edit,
      :destroy,
      :update,
      :facts,
      :related_users,
      :activities,
      :remove_fact,
      :toggle_fact,
      :add_fact,
      :remove_fact,
      :follow]

  before_filter :authenticate_user!


  def index
    authorize! :index, Channel

    respond_to do |format|
      format.json { render :json => channels_for_user(@user).map {|ch| Channels::Channel.for(channel: ch,view: view_context,channel_user: @user)} }
      format.js
    end
  end

  def show
    authorize! :show, @channel
    respond_to do |format|
      format.json { render :json => Channels::Channel.for(channel: @channel,view: view_context,channel_user: @user)}
      format.js
      format.html do
        render inline:'', layout: "channels"
        @channel.mark_as_read
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

        render :json => Channels::Channel.for(channel: @channel,view: view_context)
        return
      end

      unless params[:for_channel].nil?
        @subchannel = Channel[params[:for_channel]]
        @channel.add_channel(@subchannel)

        render :json => Channels::Channel.for(channel: @channel,view: view_context)
        return
      end

      respond_to do |format|
        format.html { redirect_to(channel_path(@channel.created_by.user, @channel), :notice => 'Channel successfully created') }
        format.js
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

    if @channel.created_by == current_user.graph_user
      @channel.delete

      respond_to do |format|
        format.html  { redirect_to(channel_path(@user, @user.graph_user.stream), :notice => 'Channel successfully deleted') }
        format.json  { render :json => {}, :status => :ok }
      end
    end
  end

  def facts
    authorize! :show, @channel
    @facts = @channel.facts(from: params[:timestamp], count: params[:number] || 7, withscores: true)

    if @channel.created_by == current_user.graph_user
      @channel.mark_as_read
    end

    respond_to do |format|
      format.json { render json: @facts.map {|fact| Facts::Fact.for(fact: fact[:item],view: view_context,channel: @channel,timestamp: fact[:score])} }
    end
  end

  def toggle_fact
    authorize! :update, @channel

    @fact     = Fact[params[:fact_id]]

    if @channel.facts.include?(@fact)
      @channel.remove_fact(@fact)
    else
      @channel.add_fact(@fact)
    end

    respond_to do |format|
      format.js
    end
  end

  def add_fact
    authorize! :update, @channel

    @fact = Fact[params[:fact_id]]

    @channel.add_fact(@fact)

    respond_with(@channel)
  end

  def remove_fact
    authorize! :update, @channel

    @fact = Fact[params[:fact_id]]

    @channel.remove_fact(@fact)

    respond_with(@channel)
  end

  def related_users
    authorize! :show, @channel

    render layout: false, partial: "channels/related_users",
      locals: {
           related_users: @channel.related_users(:without=>[current_graph_user]).andand.map{|x| x.user },
           topic: Topic.by_title(@channel.title),
           excluded_users: [@channel.created_by]
      }
  end

  def activities
    authorize! :show, @channel

    respond_to do |format|
      format.json { render json: @channel.activities.below('inf', count:17, reversed: true).keep_if{|a| a.still_valid?}.map { |activity| Activities::Activity.for(activity: activity, view: view_context) } }
      format.html { render inline:'', layout: "channels" }
    end
  end

  private
    def get_user
      if params[:username]
        @user = User.first(:conditions => { :username => params[:username]}) || raise_404
      end
    end

    def load_channel
      @channel  = Channel[params[:channel_id] || params[:id]]
      @channel || raise_404("Channel not found")
      @user ||= @channel.created_by.user
    end

    def channels_for_user(user)
      @channels = user.graph_user.channels
      unless @user == current_user
        @channels = @channels.keep_if {|ch| ch.sorted_cached_facts.count > 0 || ch.type != 'channel'}
      end
      @channels
    end
    helper_method :channels_for_user

end
