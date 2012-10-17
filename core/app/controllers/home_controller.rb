class HomeController < ApplicationController

  layout "frontend"

  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!, only: [:tos, :tour]

  #general static pages:
  def pages
    if ( /\A([-a-zA-Z_\/]+)\Z/.match(params[:name]))
      respond_to do |format|
        template = "home/pages/#{$1}"

        layout = "static_pages"

        authorize! :show, template

        format.html do
          begin
            session[:redirect_after_failed_login_path] = pages_path $1, layout: layout, show_sign_in: 1
            render template, :layout => layout
          rescue ActionView::MissingTemplate
            begin
              session[:redirect_after_failed_login_path] = pages_path "index", layout: layout, show_sign_in: 1
              render "#{template}/index", :layout => layout
            rescue ActionView::MissingTemplate
              session[:redirect_after_failed_login_path] = nil
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


  before_filter :accepts_html_instead_of_stars, only: [:index, :tos]
  def accepts_html_instead_of_stars
    # If the request 'Content Accept' header indicates a '*/*' format,
    # we set the format to :html.
    # This is necessary for GoogleBot which requests / with '*/*; q=0.6' for example.
    if request.format.to_s =~ %r%\*\/\*%
      request.format = :html
    end
  end

  def index
    session[:redirect_after_failed_login_path] = root_path(show_sign_in: 1)
    respond_to do |format|
      @code = params[:code] if ( /\A([-a-zA-Z0-9_]+)\Z/.match(params[:code]))
      format.html { render "home/pages/index", layout: "static_pages" }
    end
  end

  def tos
  end

  def tour
    current_user.seen_the_tour = true
    current_user.save
    render layout: nil
  end

  # Search
  # Not using the same search for the client popup, since we probably want\
  # to use a more advanced search on the Factlink website.
  def search
    if params[:s]
      raise HackAttempt unless params[:s].is_a? String
    end

    @row_count = 20
    row_count = @row_count
    page = params[:page] || 1;

    search_for = params[:s] || ""

    interactor = SearchInteractor.new search_for,
      ability: current_ability, page: page, row_count: row_count

    @results = interactor.execute

    @results = @results.map do |result|
      SearchResults::SearchResultItem.for(obj: result, view: view_context)
    end.delete_if {|x| x.the_object.nil?}

    respond_to do |format|
      format.html
      format.json {render json: @results}
    end
  end
end
