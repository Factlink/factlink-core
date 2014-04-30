class OpinionatorsController < ApplicationController
  respond_to :json

  def index
    render json: interactor(:'facts/votes', fact_id: params[:fact_id])
  end


  def create
    render json: interactor(:'facts/set_interesting', fact_id: params[:fact_id])
  end
  alias :update :create

  def destroy
    render json: interactor(:'facts/remove_interesting', fact_id: params[:fact_id])
  end
end
