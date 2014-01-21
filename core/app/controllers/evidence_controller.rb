class EvidenceController < ApplicationController

  before_filter :authenticate_user!, except: [:index]

  respond_to :json

  def index
    @evidence = interactor(:'comments/for_fact_id', fact_id: params[:fact_id])

    render 'evidence/index', formats: [:json]
  end
end
