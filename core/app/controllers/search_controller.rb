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
      interactor = Interactors::Search.new search_for,
        ability: current_ability, page: page, row_count: row_count

      @results = interactor.execute

      @results = @results.map do |result|
        SearchResults::SearchResultItem.for(obj: result, view: view_context)
      end.delete_if {|x| x.the_object.nil?}
    end

    respond_to do |format|
      format.html
      format.json {render json: @results}
    end
  end
end
