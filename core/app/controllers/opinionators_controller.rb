class OpinionatorsController < ApplicationController
  respond_to :json

  def index
    render json: interactor(:'facts/votes', fact_id: params[:fact_id])
  end


  def create
    render json: interactor(:'facts/set_opinion', fact_id: params[:fact_id], opinion: params[:type])
  end
  alias :update :create

  def destroy
    render json: interactor(:'facts/remove_opinion', fact_id: params[:fact_id])
  end
end
