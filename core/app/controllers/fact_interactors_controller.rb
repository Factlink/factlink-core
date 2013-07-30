class FactInteractorsController < ApplicationController
  respond_to :json

  def index
    # TODO: Make an interactor that does this once we get rid of "show"
    @interactors = [
      interactor(:'facts/opinion_users', fact_id, skip, take, 'believes'),
      interactor(:'facts/opinion_users', fact_id, skip, take, 'disbelieves'),
      interactor(:'facts/opinion_users', fact_id, skip, take, 'doubts')
    ]

    render 'fact_interactors/index', formats: ['json']
  end

  def show
    @data = old_interactor :'facts/opinion_users', fact_id, skip, take, type

    render 'fact_interactors/show', formats: ['json']
  end

  def fact_id
    params[:fact_id].to_i
  end

  def type
    OpinionType.real_for(params[:id]).to_s
  end

  def skip
    (params[:skip] || 0).to_i
  end

  def take
    (params[:take] || 3).to_i
  end
end
