class FrontendController < ApplicationController
  def show
    render inline: '', layout: 'frontend_with_backbone'
  end

  def user_profile
    unless Backend::Users.user_by_username(username: params[:username])
      fail ActionController::RoutingError.new('')
    end

    render inline: '', layout: 'frontend_with_backbone'
  end
end
