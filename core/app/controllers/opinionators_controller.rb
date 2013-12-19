class OpinionatorsController < ApplicationController
  respond_to :json

  def index
    # TODO: Make an interactor that does this once we get rid of "show"
    fact_id = params[:fact_id].to_i

    @interactors = [
      {
        type: 'believes',
        users: interactor(:'facts/opinionators', fact_id: fact_id, type: 'believes')
      },
      {
        type: 'disbelieves',
        users: interactor(:'facts/opinionators', fact_id: fact_id, type: 'disbelieves')
      },
      {
        type: 'doubts',
        users: interactor(:'facts/opinionators', fact_id: fact_id, type: 'doubts')
      }
    ]

    render :index, formats: ['json']
  end
end
