class FactsController < ApplicationController
  layout "client"

  respond_to :json, :html

  before_filter :load_fact,
    only: [
      :show,
      :discussion_page,
      :discussion_page_redirect,
      :destroy,
      :update,
      :opinion,
      :evidence_search,
      :update_opinion,
      :share
      ]

  def show
    authorize! :show, @fact

    render 'facts/show', formats: [:json]
  end

  def discussion_page
    authorize! :show, @fact

    backbone_responder
  end

  def discussion_page_redirect # remove before 2014
    authorize! :show, @fact

    redirect_path = FactUrl.new(@fact).friendly_fact_path
    redirect_to redirect_path, status: :moved_permanently
  end

  def create
    # support both old names, and names which correspond to json in show
    fact_text = (params[:fact] || params[:displaystring]).to_s
    url = (params[:url] || params[:fact_url]).to_s
    title = (params[:title] || params[:fact_title]).to_s

    sharing_options = params[:fact_sharing_options] || {}

    authenticate_user!
    authorize! :create, Fact

    @fact = interactor(:'facts/create',
                           displaystring: fact_text, url: url,
                           title: title, sharing_options: sharing_options)
    @site = @fact.site

    mp_track "Factlink: Created",
      opinion: params[:opinion],
      channels: params[:channels]
    mp_track_people_event last_factlink_created: DateTime.now

    if OpinionType.include?(params[:opinion])
      @fact.add_opinion(params[:opinion], current_user.graph_user)
      Activity::Subject.activity(current_user.graph_user, params[:opinion], @fact)
    end

    add_to_channels @fact, params[:channels]

    render 'facts/show', formats: [:json]
  end

  def destroy
    authorize! :destroy, @fact

    interactor :'facts/destroy', fact_id: @fact.id

    render json: {}
  end

  def update_opinion
    authorize! :opinionate, @fact

    if params[:current_user_opinion] == 'no_vote'
      @fact.remove_opinions(current_user.graph_user)
    else
      type = params[:current_user_opinion]
      @fact.add_opinion(type, current_user.graph_user)
      Activity::Subject.activity(current_user.graph_user, type, @fact)
    end

    render json: {}
  end

  # TODO: This search is way to simple now, we need to make sure already
  # evidenced Factlinks are not shown in search results and therefore we need
  # to move this search to the evidence_controller, to make sure it's
  # type-specific
  def evidence_search
    authorize! :index, Fact
    search_for = params[:s]

    raise_404 if Fact.invalid(@fact)
    evidence = interactor(:'search_evidence', keywords: search_for, fact_id: @fact.id)
    @facts = evidence.map { |fd| fd.fact }

    render 'facts/index', formats: [:json]
  end

  def recently_viewed
    @facts = interactor :"facts/recently_viewed"

    render 'facts/index', formats: [:json]
  end

  def share
    authorize! :share, @fact

    command :'facts/social_share', fact_id: @fact.id, sharing_options: params[:fact_sharing_options]

    render json: {}
  end

  private

  def load_fact
    @fact = interactor(:'facts/get', id: fact_id) or raise_404
  end

  def fact_id
    params[:fact_id] || params[:id]
  end

  def add_to_channels fact, channel_ids
    return unless channel_ids

    channels = channel_ids.map { |id| Channel[id] }.compact
    channels.each do |channel|
      interactor(:'channels/add_fact', fact: fact, channel: channel)
    end
  end
end
