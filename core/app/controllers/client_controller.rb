class ClientController < ApplicationController
  def blank
    render inline: '', layout: 'client'
  end
end
