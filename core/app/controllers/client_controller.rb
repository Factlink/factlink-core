class ClientController < ApplicationController
  def page
    render inline: '', layout: 'client'
  end
end
