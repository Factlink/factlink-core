class FactsController < ApplicationController

  layout "client"

  before_filter :set_layout, :only => [:new]

  respond_to :json, :html

  before_filter :load_fact,
    :only => [
      :show,
      :popup_show,
      :extended_show,
      :destroy,
      :get_channel_listing,
      :update,
      :opinion,
      :evidence_search,
      ]

  around_filter :allowed_type,
    :only => [:set_opinion ]


  def show
    authorize! :show, @fact
    @title = @fact.data.displaystring # The html <title>
    @modal = true
    @hide_links_for_site = @modal && @fact.site

    respond_with(lazy {Facts::Fact.for(fact: @fact, view: view_context)})
  end

  def extended_show
    authorize! :show, @fact

    render layout: "frontend"
  end

  def popup_show
    @fact.calculate_opinion(1)
    render layout: 'popup'
  end

  def intermediate
    render layout: nil
  end

  def new
    authorize! :new, Fact
    if session[:just_signed_in]
      session[:just_signed_in] = nil

      @just_signed_in = true
    end

    if current_user
      render layout: @layout
    else
      redirect_to user_session_path(layout: @layout)
    end
  end

  def create
    authorize! :create, Fact
    @fact = Fact.build_with_data(params[:url].to_s, params[:fact].to_s, params[:title].to_s, current_graph_user)
    @site = @fact.site


    respond_to do |format|
      if @fact.data.save and @fact.save
        #TODO switch the following two if blocks if possible
        if @fact and (params[:opinion] and [:beliefs, :believes, :doubts, :disbeliefs, :disbelieves].include?(params[:opinion].to_sym))
          @fact.add_opinion(params[:opinion].to_sym, current_user.graph_user)
          @fact.calculate_opinion(1)
        end

        if params[:channels]
          params[:channels].each do |channel_id|
            channel = Channel[channel_id]
            if channel # in case the channel got deleted between opening the add-fact dialog, and submitting
              authorize! :update, channel

              channel.add_fact(@fact)
            end
          end
        end

        format.html do
          flash[:notice] = "Factlink successfully posted. <a href=\"#{friendly_fact_path(@fact)}\" target=\"_blank\">View on Factlink.com</a>".html_safe
          redirect_to controller: 'facts', action: 'popup_show', id: @fact.id, only_path: true
        end
        format.json { render json: @fact, status: :created, location: @fact.id }
      else
        format.html { render :new }
        format.json { render json: @fact.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_channel_listing
    authorize! :index, Channel
    @channels = current_user.graph_user.editable_channels_for(@fact)
    respond_to do |format|
      format.json { render :json => @channels, :callback => params[:callback], :content_type => "text/javascript" }
      format.html { render 'channel_listing', layout: nil }
    end
  end

  def destroy
    authorize! :destroy, @fact

    @fact_id = @fact.id
    @fact.delete

    respond_with(@fact)
  end

  # This update now only supports setting the title, for use in Backbone Views
  def update
    authorize! :update, @fact

    @fact.data.title = params[:title]

    if @fact.data.save
      render :json => {}, :status => :ok
    else
      render :json => @fact.errors, :status => :unprocessable_entity
    end
  end

  def opinion
    render :json => {"opinions" => @fact.get_opinion(3).as_percentages}, :callback => params[:callback], :content_type => "text/javascript"
  end

  def set_opinion
    type = params[:type].to_sym
    @basefact = Basefact[params[:id]]

    authorize! :opinionate, @basefact

    @basefact.add_opinion(type, current_user.graph_user)
    @basefact.calculate_opinion(2)

    render json: Facts::FactWheel.for(fact: @basefact, view: view_context)
  end

  def remove_opinions
    @basefact = Basefact[params[:id]]

    authorize! :opinionate, @basefact

    @basefact.remove_opinions(current_user.graph_user)
    @basefact.calculate_opinion(2)

    render json: Facts::FactWheel.for(fact: @basefact, view: view_context)
  end

  # TODO: This search is way to simple now, we need to make sure already
  # evidenced Factlinks are not shown in search results and therefore we need
  # to move this search to the evidence_controller, to make sure it's
  # type-specific
  def evidence_search
    authorize! :index, Fact
    search_for = params[:s]
    search_for = search_for.split(/\s+/).select{|x|x.length > 2}.join(" ")
    if search_for.length > 0
      solr_result = Sunspot.search FactData do
        fulltext search_for do
          highlight :displaystring
        end
      end

      results = solr_result.results.delete_if {|fd| FactData.invalid(fd)}
      facts = results.
        reject {|result| result.fact.id == @fact.id}.
        map do |result|
          Facts::FactBubble.for(fact: result.fact, view: view_context)
        end
    else
      facts = []
    end
    render json: facts
  end

  private
    def load_fact
      id = params[:fact_id] || params[:id]

      @fact = Fact[id] || raise_404
    end

    def allowed_type
      allowed_types = [:beliefs, :doubts, :disbeliefs,:believes, :disbelieves]
      type = params[:type].to_sym
      if allowed_types.include?(type)
        yield
      else
        render :json => {"error" => "type not allowed"}, :status => 500
        false
      end
    end

    def friendly_fact_path(fact)
      slug = fact.to_s.blank? ? fact.id : fact.to_s.parameterize
      frurl_fact_path(slug, fact.id)
    end
end
