class SitesController < ApplicationController
  before_filter :retrieve_facts_for_url, except: :blacklisted

  #TODO: make sure this is executed whenever possible
  before_filter :register_client_version_numbers, only: :facts_count_for_url

  prepend_before_filter :check_blacklist

  def facts_count_for_url
    response = {count: @facts.count}
    response[:jslib_url] = jslib_url_for(current_user.username).to_s if user_signed_in?
    render :json => response, :callback => params[:callback], :content_type => "application/javascript"
  end

  def facts_for_url
    render :json => @facts , :callback => params[:callback], :content_type => "application/javascript"
  end

  def blacklisted
    render json: {}
  end

  private
    def retrieve_facts_for_url
      authorize! :index, Fact
      url = params[:url]
      site = Site.find(:url => url).first
      @facts = site ? site.facts.to_a : []
    end

    def check_blacklist
      authorize! :check, Blacklist
      if Blacklist.default.matches? params[:url]
        render :json => { :blacklisted => true }, :callback => params[:callback], :content_type => "application/javascript"
      end
    end

    def register_client_version_numbers
      extension_version = request.headers["extensionVersion"]
      user_agent        = request.headers["userAgent"]

      track_people_event user_agent: user_agent, extension_version: extension_version
    end
end
