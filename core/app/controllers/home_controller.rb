class HomeController < ApplicationController

  layout "web-frontend-v2"

  helper_method :sort_column, :sort_direction
  
  def index
    @facts = Fact.all.sort(:order => "DESC")
    @users = User.all[0..10]
  end
  
  # Search
  # Not using the same search for the client popup, since we probably want\
  # to use a more advanced search on the Factlink website.
  def search
    @row_count = 5
    row_count = @row_count

    if params[:s]
      solr_result = FactData.search() do

        keywords params[:s], :fields => [:displaystring]
        order_by sort_column, sort_direction
        paginate :page => params[:page] , :per_page => row_count

        adjust_solr_params do |sunspot_params|
          sunspot_params[:rows] = row_count
        end
      end

      @facts = solr_result.results
      
      puts "\n\nFacts:"
      puts @facts
      
    else
      # will_paginate sorting doesn't work very well on arrays.. Fixed it..
      @facts = WillPaginate::Collection.create( params[:page] || 1, row_count ) do |pager|
        start = (pager.current_page-1)*row_count

        # Sorting & filtering done by mongoid
        results = FactData.all(:sort => [[sort_column, sort_direction]]).skip(start).limit(row_count).to_a
        pager.replace(results)
      end
    end

    @facts = @facts.map { |factdata| factdata.fact }

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
