class SearchController < ApplicationController
  # Search
  # Not using the same search for the client popup, since we probably want
  # to use a more advanced search on the Factlink website.
  def search
    backbone_responder do
      render json: interactor(:'search', keywords: params[:s])
    end
  end
end
