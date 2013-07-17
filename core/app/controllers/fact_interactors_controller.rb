class FactInteractorsController < ApplicationController
  respond_to :json

  def interactors

  end

  def filtered_interactors
    @data = interactor :'facts/opinion_users', fact_id, skip, take, type

    render 'facts/interactions', formats: ['json']
  end

  def fact_id
    params[:id].to_i
  end

  def type
    OpinionType.real_for(params[:type]).to_s
  end

  def skip
    (params[:skip] || 0).to_i
  end

  def take
    (params[:take] || 3).to_i
  end
end
