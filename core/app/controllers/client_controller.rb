class ClientController < ApplicationController
  def blank
    render inline: '', layout: 'client'
  end

  def facts_new
    authorize! :new, Fact
    authenticate_user!

    render inline: '', layout: 'client'
  end
end
