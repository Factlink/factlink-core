class OpinionatorsController < ApplicationController
  respond_to :json

  def index
    votes = interactor(:'facts/votes', fact_id: params[:fact_id])
    render json: votes
  end


  def create
    @fact = Fact[fact_id]
    authorize! :opinionate, @fact

    type = params[:type]
    @fact.add_opinion(type, current_user.graph_user)

    render json: {}
  end
  alias :update :create

  def destroy
    @fact = Fact[fact_id]
    authorize! :opinionate, @fact

    @fact.remove_opinions(current_user.graph_user)

    render json: {}
  end

  private

  def fact_id
    params[:fact_id].to_i
  end
end
