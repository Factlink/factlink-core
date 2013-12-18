class OpinionatorsController < ApplicationController
  respond_to :json

  def index
    # TODO: Make an interactor that does this once we get rid of "show"
    fact_id = params[:fact_id].to_i

    @interactors = [
      interactor(:'facts/opinionators', fact_id: fact_id, type: 'believes'),
      interactor(:'facts/opinionators', fact_id: fact_id, type: 'disbelieves'),
      interactor(:'facts/opinionators', fact_id: fact_id, type: 'doubts')
    ]

    render 'fact_interactors/index', formats: ['json']
  end
end
