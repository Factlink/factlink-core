class SitesController < ApplicationController
  #TODO: make sure this is executed whenever possible
  before_filter :register_client_version_numbers, only: :facts_count_for_url

  def facts_count_for_url
    authorize! :get_fact_count, Site
    url = params[:url]
    if is_blacklisted
      response = { blacklisted: 'This site is not supported' }
    else
      site = Site.find(:url => url).first
      @facts_count = site ? site.facts.count : 0
      response = { count: @facts_count }
    end
    response[:jslib_url] = jslib_url_for(current_user.username).to_s if user_signed_in?

    render_json response
  end

  def facts_for_url
    url = params[:url]
    if is_blacklisted
      render_json blacklisted: 'This site is not supported'
    else
      authorize! :index, Fact
      site = Site.find(:url => url).first
      @facts = site ? site.facts.to_a : []

      render_json @facts
    end
  end

  def blacklisted
    render_json is_blacklisted ? { blacklisted: 'This site is not supported' } : {}
  end

  def top_topics
    @topics = query :'site/top_topics', params[:id].to_i
    render 'topics/index'
  end

  private
    def render_json json_able
      render :json => json_able , :callback => params[:callback], :content_type => "application/javascript"
    end

    def is_blacklisted
      Blacklist.default.matches? params[:url]
    end

    def register_client_version_numbers
      extension_version = request.headers["extensionVersion"]
      user_agent        = request.headers["userAgent"]

      track_people_event user_agent: user_agent, extension_version: extension_version
    end
end
