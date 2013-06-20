class FactsController < ApplicationController
  layout "client"

  before_filter :set_layout, only: [:new, :create]

  respond_to :json, :html

  before_filter :parse_pagination_parameters,
    only: [:believers, :disbelievers, :doubters]

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
        dead_fact = query :'facts/get_dead', @fact.id
        open_graph_fact = OpenGraph::Objects::OgFact.new dead_fact
        open_graph_formatter.add open_graph_fact

        render inline:'', layout: 'client'
      end
      format.json { render }
    end
  end

  def discussion_page
    authorize! :show, @fact

    backbone_responder
  end

  # TODO combine next three methods
  def believers
    fact_id = params[:id].to_i
    data = interactor :'facts/opinion_users', fact_id, @skip, @take, 'believes'

    render_interactions data
  end

  def disbelievers
    fact_id = params[:id].to_i
    data = interactor :'facts/opinion_users', fact_id, @skip, @take, 'disbelieves'

    render_interactions data
  end

  def doubters
    fact_id = params[:id].to_i
    data = interactor :'facts/opinion_users', fact_id, @skip, @take, 'doubts'

    render_interactions data
  end

  def intermediate
    render layout: nil
  end

  def new
    authorize! :new, Fact
    authenticate_user!

    render inline:'', layout: 'client'
  end

  def create
    # support both old names, and names which correspond to json in show
    fact_text = (params[:fact] || params[:displaystring]).to_s
    url = (params[:url] || params[:fact_url]).to_s
    title = (params[:title] || params[:fact_title]).to_s

    authenticate_user!
    authorize! :create, Fact

    @fact = interactor :'facts/create', fact_text, url, title
    @site = @fact.site

    respond_to do |format|
      mp_track "Factlink: Created"

      #TODO switch the following two if blocks if possible
      if @fact and (params[:opinion] and [:beliefs, :believes, :doubts, :disbeliefs, :disbelieves].include?(params[:opinion].to_sym))
        @fact.add_opinion(params[:opinion].to_sym, current_user.graph_user)
        Activity::Subject.activity(current_user.graph_user, Opinion.real_for(params[:opinion]), @fact)

        @fact.calculate_opinion(1)
      end

      add_to_channels @fact, params[:channels]

      format.json { render 'facts/show' }
    end
  end

  def destroy
    authorize! :destroy, @fact

    @fact_id = @fact.id
    @fact.delete

    render json: @fact
  end

  def set_opinion
    type = params[:type].to_sym
    authorize! :opinionate, @fact

    @fact.add_opinion(type, current_user.graph_user)
    Activity::Subject.activity(current_user.graph_user, Opinion.real_for(type), @fact)

    @fact.calculate_opinion(2)

    render_factwheel(@fact.id)
  end

  def remove_opinions
    authorize! :opinionate, @fact

    @fact.remove_opinions(current_user.graph_user)
    Activity::Subject.activity(current_user.graph_user,:removed_opinions,@fact)
    @fact.calculate_opinion(2)

    render_factwheel(@fact.id)
  end

  def render_factwheel(fact_id)
    dead_fact_wheel = query 'facts/get_dead_wheel', fact_id.to_s
    render 'facts/_fact_wheel', format: :json, locals: {dead_fact_wheel: dead_fact_wheel}
  end

  # TODO: This search is way to simple now, we need to make sure already
  # evidenced Factlinks are not shown in search results and therefore we need
  # to move this search to the evidence_controller, to make sure it's
  # type-specific
  def evidence_search
    authorize! :index, Fact
    search_for = params[:s]

    @facts = (interactor :search_evidence, search_for, @fact.id).map do |fd|
        fd.fact
      end

    render 'facts/index', formats: [:json]
  end

  def recently_viewed
    @facts = interactor :"facts/recently_viewed"

    render 'facts/index', formats: [:json]
  end

  private
    def load_fact
      @fact = interactor :'facts/get', fact_id || raise_404
    end

    def fact_id
      params[:fact_id] || params[:id]
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

    def parse_pagination_parameters
      params[:skip] ||= '0'
      @skip = params[:skip].to_i

      params[:take] ||= '3'
      @take = params[:take].to_i
    end

    def render_interactions data
      @users = data[:users]
      @total = data[:total]

      render 'facts/interactions', format: 'json'
    end

    def add_to_channels fact, channel_ids
      return unless channel_ids

      channels = channel_ids.map{|id| Channel[id]}.compact
      channels.each do |channel|
        interactor :"channels/add_fact", fact, channel
      end
    end
end
