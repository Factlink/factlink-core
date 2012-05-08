class SitesController < ApplicationController
  before_filter :retrieve_facts_for_url, except: :blacklisted
  prepend_before_filter :retrieve_facts_for_url, :check_blacklist

  def facts_count_for_url
    render :json => { :count => @facts.count }, :callback => params[:callback], :content_type => "application/javascript"
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
end
