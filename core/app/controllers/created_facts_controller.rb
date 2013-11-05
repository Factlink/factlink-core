class CreatedFactsController < ApplicationController
  def index
    @facts = interactor(:'facts/created_by_user',
                   username: params[:username].to_s,
                   count: params.fetch(:number, 7).to_i,
                   from: params[:timestamp])

    render 'channels/facts'
  end
end
