class ClientController < ApplicationController
  def show
    render inline: '', layout: 'client'
  end
end
