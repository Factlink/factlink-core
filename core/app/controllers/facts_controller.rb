class FactsController < ApplicationController
  layout "client"

  before_filter :set_layout, only: [:new, :create]

  respond_to :json, :html

  before_filter :load_fact,
    only: [
      :show,
      :discussion_page,
      :destroy,
      :update,
      :opinion,
      :evidence_search,
      :set_opinion,
      :remove_opinions
      ]

  around_filter :allowed_type,
    :only => [:set_opinion ]

  def show
    authorize! :show, @fact

    respond_to do |format|
      format.html do
        dead_fact = old_query :'facts/get_dead', @fact.id
        open_graph_fact = OpenGraph::Objects::OgFact.new dead_fact
        open_graph_formatter.add open_graph_fact

        render inline: '', layout: 'client'
      end
      format.json { render }
    end
  end

  def discussion_page
    authorize! :show, @fact

    backbone_responder
  end

  def intermediate
    render layout: nil
  end

  def new
    authorize! :new, Fact
    authenticate_user!

    render inline: '', layout: 'client'
  end

  def create
    # support both old names, and names which correspond to json in show
    fact_text = (params[:fact] || params[:displaystring]).to_s
    url = (params[:url] || params[:fact_url]).to_s
    title = (params[:title] || params[:fact_title]).to_s

    sharing_options = params[:fact_sharing_options] || {}

    authenticate_user!
    authorize! :create, Fact

    @fact = old_interactor :'facts/create', fact_text, url, title, sharing_options
    @site = @fact.site

    respond_to do |format|
      mp_track "Factlink: Created"

      #TODO switch the following two if blocks if possible
      if @fact and (params[:opinion] and ['beliefs', 'believes', 'doubts', 'disbeliefs', 'disbelieves'].include?(params[:opinion]))
        @fact.add_opinion(OpinionType.real_for(params[:opinion]), current_user.graph_user)
        Activity::Subject.activity(current_user.graph_user, OpinionType.real_for(params[:opinion]), @fact)

        old_command :'opinions/recalculate_fact_opinion', @fact
      end

      add_to_channels @fact, params[:channels]

      format.json { render 'facts/show' }
    end
  end

  def destroy
    authorize! :destroy, @fact

    @fact.delete

    render json: {}
  end

  def set_opinion
    type = OpinionType.real_for(params[:type])
    authorize! :opinionate, @fact

    @fact.add_opinion(type, current_user.graph_user)
    Activity::Subject.activity(current_user.graph_user, OpinionType.real_for(type), @fact)
    old_command :'opinions/recalculate_fact_opinion', @fact

    render_factwheel(@fact.id)
  end

  def remove_opinions
    authorize! :opinionate, @fact

    @fact.remove_opinions(current_user.graph_user)
    Activity::Subject.activity(current_user.graph_user,:removed_opinions,@fact)
    old_command :'opinions/recalculate_fact_opinion', @fact

    render_factwheel(@fact.id)
  end

  def render_factwheel(fact_id)
    dead_fact_wheel = old_query 'facts/get_dead_wheel', fact_id.to_s
    render 'facts/_fact_wheel', format: :json, locals: {dead_fact_wheel: dead_fact_wheel}
  end

  # TODO: This search is way to simple now, we need to make sure already
  # evidenced Factlinks are not shown in search results and therefore we need
  # to move this search to the evidence_controller, to make sure it's
  # type-specific
  def evidence_search
    authorize! :index, Fact
    search_for = params[:s]

    @facts = (old_interactor :search_evidence, search_for, @fact.id).map do |fd|
        fd.fact
      end

    render 'facts/index', formats: [:json]
  end

  def recently_viewed
    @facts = old_interactor :"facts/recently_viewed"

    render 'facts/index', formats: [:json]
  end

  private

  def load_fact
    @fact = old_interactor :'facts/get', fact_id || raise_404
  end

  def fact_id
    params[:fact_id] || params[:id]
  end

  def allowed_type
    # TODO REFACTOR SUCH THAT set_opinion rescues exception from opiniontype
    allowed_types = ['beliefs', 'doubts', 'disbeliefs', 'believes', 'disbelieves']
    type = params[:type]
    if allowed_types.include?(type)
      yield
    else
      render :json => {"error" => "type not allowed"}, :status => 500
      false
    end
  end


  def add_to_channels fact, channel_ids
    return unless channel_ids

    channels = channel_ids.map{|id| Channel[id]}.compact
    channels.each do |channel|
      old_interactor :"channels/add_fact", fact, channel
    end
  end
end
