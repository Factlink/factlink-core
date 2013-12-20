class OpinionatorsController < ApplicationController
  respond_to :json

  def index
    # TODO: Make an interactor that does this once we get rid of "show"
    fact_id = params[:fact_id].to_i

    @interactors = interactor(:'facts/votes', fact_id: fact_id)
    render :index, formats: ['json']
  end
end
