class SearchController < ApplicationController
  # Search
  # Not using the same search for the client popup, since we probably want
  # to use a more advanced search on the Factlink website.
  def search
    if params[:s]
      fail HackAttempt unless params[:s].is_a? String
    end

    backbone_responder do
      row_count = 20

      search_for = params[:s] || ""
      page = 1

      @results = []

      if search_for.size > 0
        @results = interactor(:'search', keywords: search_for, page: page, row_count: row_count)
      end

      real_results = @results.map do |result|
        the_class = case result
                    when DeadFact then "Annotation"
                    when DeadUser then "User"
                    end
        {
          the_class: the_class,
          the_object: result
        }
      end
      render json: real_results
    end
  end
end
