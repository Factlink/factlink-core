class SearchController < ApplicationController

  layout "frontend"

  # Search
  # Not using the same search for the client popup, since we probably want\
  # to use a more advanced search on the Factlink website.
  def search
    if params[:s]
      raise HackAttempt unless params[:s].is_a? String
    end

    track "Search: Top bar search"

    @row_count = 20
    row_count = @row_count
    page = params[:page] || 1;

    search_for = params[:s] || ""

    @results = []

    if search_for.size > 0
      @results = interactor :search, search_for, page, row_count
    end

    respond_to do |format|
      format.html
      format.json { render 'search_results/index' }
    end
  end
end
