class SearchController < ApplicationController
  # Search
  # Not using the same search for the client popup, since we probably want
  # to use a more advanced search on the Factlink website.
  def search
    if params[:s]
      fail HackAttempt unless params[:s].is_a? String
    end

    backbone_responder do
      row_count = 20 # WARNING: coupling with SearchResultView

      search_for = params[:s] || ""
      page = 1

      @results = []

      if search_for.size > 0
        @results = interactor(:'search', keywords: search_for, page: page, row_count: row_count)
      end

      render 'search_results/index'
    end
  end
end
