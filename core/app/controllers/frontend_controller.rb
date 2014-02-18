class FrontendController < ApplicationController
  def show
    render inline: '', layout: 'frontend_with_backbone'
  end
end
