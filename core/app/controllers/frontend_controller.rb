class FrontendController < ApplicationController
  def show
    render inline: '', layout: 'frontend_with_backbone'
  end

  def user_profile
    Backend::Users.user_by_username(username: params[:username]) or raise_404

    render inline: '', layout: 'frontend_with_backbone'
  end
end
