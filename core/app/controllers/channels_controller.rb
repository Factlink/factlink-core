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
    @channels = @user.graph_user.channels

    respond_to do |format|
      format.json { render :json => @channels.map {|ch| Channels::SingleMenuItem.for(channel: ch,view: view_context,channel_user: @user)} }
      format.js
    end
  end

  def show
    authorize! :show, @channel
    respond_to do |format|
      format.json { render :json => Channels::SingleMenuItem.for(channel: @channel,view: view_context,channel_user: @user)}
      format.js
      format.html do
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

    @channel = Channel.new(params[:channel] || params.slice(:title))
    @channel.created_by = current_user.graph_user

    # Check if object valid, then execute:
    if @channel.valid?
      @channel.save

      unless params[:for_fact].nil?
        @fact = Fact[params[:for_fact]]
        @channel.add_fact(@fact)

        render :json => Channels::SingleMenuItem.for(channel: @channel,view: view_context)
        return
      end

      unless params[:for_channel].nil?
        @subchannel = Channel[params[:for_channel]]
        @channel.add_channel(@subchannel)

        render :json => Channels::SingleMenuItem.for(channel: @channel,view: view_context)
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

    respond_with(@facts.map {|fact| Facts::Fact.for_fact_and_view(fact[:item],view_context,@channel,nil,fact[:score])})
  end

  def remove_fact
    authorize! :update, @channel
    @fact = Fact[params[:fact_id]]
    @channel.remove_fact(@fact)

    respond_with(@fact)
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

    @fact     = Fact[params[:fact_id]]

    @channel.add_fact(@fact)

    respond_with(@channel)
  end

  def remove_fact
    authorize! :update, @channel

    @fact = Fact[params[:fact_id]]

    @channel.remove_fact(@fact)

    respond_with(@channel)
  end

  def follow
    @channel.fork(current_user.graph_user)
  end

  def related_users
    authorize! :show, @channel

    render layout: false, partial: "channels/related_users",
      locals: {
           related_users: @channel.related_users(:without=>[current_graph_user]).andand.map{|x| x.user },
           excluded_users: [@channel.created_by]
      }
  end

  def activities
    authorize! :show, @channel
    render layout:false, partial: "channels/activity_list",
      locals: {
             channel: @channel
      }
  end

  private
    def get_user
      if params[:username]
        @user = User.first(:conditions => { :username => params[:username]})
      end
    end

    def load_channel
      @channel  = Channel[params[:channel_id] || params[:id]]
      @channel || raise_404("Channel not found")
      @user ||= @channel.created_by.user
    end
end
