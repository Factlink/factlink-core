class HomeController < ApplicationController

  layout "frontend"

  helper_method :sort_column, :sort_direction

  #general static pages:
  def pages
    if ( /\A([-a-zA-Z_\/]+)\Z/.match(params[:name]))
      respond_to do |format|
        template = "home/pages/#{$1}"

        layout = "static_pages"

        authorize! :show, template

        format.html do
          begin
            render template, :layout => layout
          rescue ActionView::MissingTemplate
            begin
              render "#{template}/index", :layout => layout
            rescue ActionView::MissingTemplate
              raise_404
            end
          end
        end
      end
    else
      raise_404
    end
  end

  before_filter :redirect_logged_in_user, only: :index
  def redirect_logged_in_user
    redirect_to after_sign_in_path_for(current_user) and return false if user_signed_in?
  end

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
    respond_to do |format|
      @code = params[:code] if ( /\A([-a-zA-Z0-9_]+)\Z/.match(params[:code]))
      format.html { render "home/pages/index", layout: "static_pages" }
    end
  end
end
