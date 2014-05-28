class ClientController < ApplicationController
  skip_before_filter :set_x_frame_options_header
  def show
    render inline: '', layout: 'client'
  end
end
