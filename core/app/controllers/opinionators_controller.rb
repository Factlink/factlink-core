class OpinionatorsController < ApplicationController
  respond_to :json

  def index
    fact_id = params[:fact_id].to_i

    @votes = interactor(:'facts/votes', fact_id: fact_id)
    render :index, formats: ['json']
  end
end
