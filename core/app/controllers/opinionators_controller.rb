class OpinionatorsController < ApplicationController
  respond_to :json

  def index
    # TODO: Make an interactor that does this once we get rid of "show"
    fact_id = params[:fact_id].to_i

    @interactors = [
      interactor(:'facts/opinionators', fact_id: fact_id, type: 'believes')
        .map {|user| {user: user, type: 'believes'}},
      interactor(:'facts/opinionators', fact_id: fact_id, type: 'disbelieves')
        .map {|user| {user: user, type: 'disbelieves'}},
      interactor(:'facts/opinionators', fact_id: fact_id, type: 'doubts')
        .map {|user| {user: user, type: 'doubts'}},
    ].flatten

    render :index, formats: ['json']
  end
end
