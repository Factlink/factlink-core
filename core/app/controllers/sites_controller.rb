class SitesController < ApplicationController
  # TODO: make sure this is executed whenever possible
  before_filter :register_client_version_numbers, only: :facts_count_for_url

  # this action is called so many times, and is so fast
  # it totally distorts our newrelic stats, therefore
  # not counted in apdex
  newrelic_ignore_apdex only: [:facts_count_for_url] if defined?(NewRelic)

  def facts_count_for_url
    authorize! :get_fact_count, Site
    url = params[:url]
    if is_blacklisted
      response = { blacklisted: 'This site is not supported' }
    else
      site = Site.find(:url => url).first
      facts_count = site ? site.facts.count : 0
      response = { count: facts_count }
    end
    response[:jslib_url] = jslib_url

    render_jsonp response
  end

  def facts_for_url
    url = params[:url]

    if is_blacklisted
      render_jsonp blacklisted: 'This site is not supported'
      return
    end

    unless can? :index, Fact
      render_jsonp error: 'Unauthorized'
      return
    end

    site = Site.find(url: url).first
    facts = site ? site.facts.to_a : []

    facts = facts.map do |fact|
      {
        id: fact.id,
        displaystring: fact.data.displaystring,
        title: fact.data.title
      }
    end

    render_jsonp facts
  end

  def blacklisted
    render_jsonp is_blacklisted ? { blacklisted: 'This site is not supported' } : {}
  end

  def top_topics
    @topics = interactor :'site/top_topics', params[:url], 3
    render 'topics/index', formats: [:json]
  end

  private

  def render_jsonp json_able
    if params[:callback]
      render json: json_able, callback: params[:callback], content_type: "application/javascript"
    else
      render json: json_able
    end
  end

  def is_blacklisted
    Blacklist.default.matches? params[:url]
  end

  def register_client_version_numbers
    extension_version = request.headers["extensionVersion"]
    user_agent        = request.headers["userAgent"]

    mp_track_people_event user_agent: user_agent, extension_version: extension_version
  end
end
