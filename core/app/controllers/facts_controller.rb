class FactsController < ApplicationController
  include FactHelper

  layout "client"

  before_filter :set_layout, :only => [:new, :create]

  respond_to :json, :html

  before_filter :parse_pagination_parameters,
    only: [:believers, :disbelievers, :doubters]

  before_filter :load_fact,
    :only => [
      :show,
      :extended_show,
      :destroy,
      :update,
      :opinion,
      :evidence_search,
      ]

  around_filter :allowed_type,
    :only => [:set_opinion ]

  def show
    authorize! :show, @fact

    respond_to do |format|
      format.html do
        render inline:'', layout: 'client'
      end
      format.json { render }
    end
  end

  def extended_show
    authorize! :show, @fact
    render_backbone_page
  end

  def believers
    fact_id = params[:id].to_i
    data = interactor :fact_believers, fact_id, @skip, @take

    render_interactions data
  end

  def disbelievers
    fact_id = params[:id].to_i
    data = interactor :fact_disbelievers, fact_id, @skip, @take

    render_interactions data
  end

  def doubters
    fact_id = params[:id].to_i
    data = interactor :fact_doubters, fact_id, @skip, @take

    render_interactions data
  end

  def intermediate
    render layout: nil
  end

  def new
    authorize! :new, Fact
    authenticate_user!

    if current_ability.signed_in?
      render inline:'', layout: 'client'
    else
      render text: '<h1>Here will be a login screen after removing :act_as_non_signed_in feature</h1>'
    end
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
      track "Factlink: Created"

      #TODO switch the following two if blocks if possible
      if @fact and (params[:opinion] and [:beliefs, :believes, :doubts, :disbeliefs, :disbelieves].include?(params[:opinion].to_sym))
        @fact.add_opinion(params[:opinion].to_sym, current_user.graph_user)
        Activity::Subject.activity(current_user.graph_user, Opinion.real_for(params[:opinion]), @fact)

        @fact.calculate_opinion(1)
      end

      if params[:channels]
        params[:channels].each do |channel_id|
          channel = Channel[channel_id]
          if channel # in case the channel got deleted between opening the add-fact dialog, and submitting
            interactor :"channels/add_fact", @fact, channel
          end
        end
      end

      format.html do
        track "Modal: Create"
        redirect_to fact_path(@fact.id, guided: params[:guided])
      end
      format.json { render 'facts/show' }
    end
  end

  def destroy
    authorize! :destroy, @fact

    @fact_id = @fact.id
    @fact.delete

    respond_with(@fact)
  end

  def opinion
    render :json => {"opinions" => @fact.get_opinion(3).as_percentages}, :callback => params[:callback], :content_type => "text/javascript"
  end

  def set_opinion
    type = params[:type].to_sym
    @basefact = Basefact[params[:id]]

    authorize! :opinionate, @basefact

    @basefact.add_opinion(type, current_user.graph_user)
    Activity::Subject.activity(current_user.graph_user, Opinion.real_for(type), @basefact)

    @basefact.calculate_opinion(2)

    render 'facts/_fact_wheel', format: :json, locals: {fact: @basefact}
  end

  def remove_opinions
    @basefact = Basefact[params[:id]]

    authorize! :opinionate, @basefact

    @basefact.remove_opinions(current_user.graph_user)
    Activity::Subject.activity(current_user.graph_user,:removed_opinions,@basefact)
    @basefact.calculate_opinion(2)

    render 'facts/_fact_wheel', format: :json, locals: {fact: @basefact}
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
end
