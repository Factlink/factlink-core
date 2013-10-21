class CreatedFactsController < ApplicationController
  def index
    user ||= query(:'user_by_username', username: params[:username])
    @facts = query(:'facts/get_paginated',
                   key: user.graph_user.sorted_created_facts.key.to_s,
                   count: params.fetch(:number, 7).to_i,
                   from: params[:timestamp])

    render 'channels/facts'
  end
end
