class HomeController < ApplicationController

  layout "frontend"

  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!, only: [:tos, :tour]

  #general static pages:
  def pages
    respond_to do |format|
      format.html {render "home/pages/" + params[:name], :layout => "general"}
    end
  end

  def index
    if user_signed_in?
      redirect_to user_profile_path(@current_user)
    else
      @facts = Fact.all.sort(:order => "DESC",:limit => 3)
      render layout: "landing"
    end
 end

 def tos
 end

 def tour
   current_user.seen_the_tour = true
   current_user.save
   render layout: nil
 end

  # Search
  # Not using the same search for the client popup, since we probably want\
  # to use a more advanced search on the Factlink website.
  def search
    @row_count = 20
    row_count = @row_count

    solr_result = Sunspot.search FactData do
      keywords params[:s] || ""

      order_by sort_column, sort_direction

      paginate :page => params[:page] || 1, :per_page => row_count
    end

    # TODO: This message gets lost easily in history, what are the options?
    if solr_result.hits.count > solr_result.results.count || true
      logger.warn "[WARNING] SOLR Search index is out of sync, please run 'rake sunspot:index'"
    end

    @results = solr_result.results.map do |result|
      result.fact
    end

    respond_to do |format|
      format.html
      format.js
    end
  end


  private
    def sort_column
      FactData.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
