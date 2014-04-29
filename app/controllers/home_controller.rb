class HomeController < ApplicationController

  layout "static_pages"

  before_filter :accepts_html_instead_of_stars, only: [:index]
  def accepts_html_instead_of_stars
    # If the request 'Content Accept' header indicates a '*/*' format,
    # we set the format to :html.
    # This is necessary for GoogleBot which requests / with '*/*; q=0.6' for example.
    if request.format.to_s =~ %r%\*\/\*%
      request.format = :html
    end
  end

  def index
    flash.keep
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    else
      render 'landing'
    end
  end
end
