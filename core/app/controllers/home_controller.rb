class HomeController < ApplicationController

  layout "frontend"

  helper_method :sort_column, :sort_direction

  def index
    if user_signed_in?
        redirect_to user_profile_path(@current_user.username)
    end
    @facts = Fact.all.sort(:order => "DESC",:limit => 10)
    @users = GraphUser.top(20).map { |gu| gu.user }
    @activities = []
  end

  # Search
  # Not using the same search for the client popup, since we probably want\
  # to use a more advanced search on the Factlink website.
  def search
    @row_count = 20
    row_count = @row_count
    
    solr_result = Sunspot.search FactData, User do
      keywords params[:s] || ""
      
      paginate :page => params[:page] || 1, :per_page => row_count
    end
    
    # TODO: This message gets lost easily in history, what are the options?
    if solr_result.hits.count > solr_result.results.count || true
      logger.warn "[WARNING] SOLR Search index is out of sync, please run 'rake sunspot:index'"
    end

    @results = solr_result.results.map do |result|
      begin
        result.fact
      rescue
        result
      end
    end

    respond_to do |format|
      format.html # search.html.erb
      format.js
    end
  end


  private
  def sort_column # private
    FactData.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction # private
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
