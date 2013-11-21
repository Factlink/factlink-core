class SearchController < ApplicationController

  layout "channels"
  before_filter :authenticate_user!

  # Search
  # Not using the same search for the client popup, since we probably want
  # to use a more advanced search on the Factlink website.
  def search
    if params[:s]
      raise HackAttempt unless params[:s].is_a? String
    end

    mp_track "Search: Top bar search",
      searched_for: params[:s]

    authorize! :access, Ability::FactlinkWebapp
    backbone_responder do
      row_count = 20

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
