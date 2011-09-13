class HomeController < ApplicationController

  layout "frontend"

  helper_method :sort_column, :sort_direction

  def index
    @facts = Fact.all.sort(:order => "DESC",:limit => 10)
    @users = GraphUser.top(20).map { |gu| gu.user }
    @activities = []
  end

  # Search
  # Not using the same search for the client popup, since we probably want\
  # to use a more advanced search on the Factlink website.
  def search
    @row_count = 5
    row_count = @row_count
    
    solr_result = Sunspot.search FactData, User do
      keywords params[:s]
      paginate :page => params[:page], :per_page => row_count
      
      adjust_solr_params do |sunspot_params|
        sunspot_params[:rows] = row_count
      end
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
    Fact.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction # private
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
