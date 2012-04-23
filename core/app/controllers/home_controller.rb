class HomeController < ApplicationController

  layout "frontend"

  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!, only: [:tos, :tour]

  #general static pages:
  def pages
    if ( /\A([-a-zA-Z_]+)\Z/.match(params[:name]))
      respond_to do |format|
        template = "home/pages/#{$1}"
        format.html do
          begin
            render template, :layout => "general"
          rescue ActionView::MissingTemplate
            raise_404
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

  def index
    # If the request 'Content Accept' header indicates a '*/*' format,
    # we set the format to :html.
    # This is necessary for GoogleBot which requests / with '*/*; q=0.6' for example.
    if request.format.to_s =~ %r%\*\/\*%
      request.format = :html
    end

    respond_to do |format|
      format.html { render layout: "landing" }
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
    authorize! :index, Fact
    if params[:s]
      raise HackAttempt unless params[:s].is_a? String
    end
    @row_count = 20
    row_count = @row_count

    search_for = params[:s] || ""
    search_for = search_for.split(/\s+/).select{|x|x.length > 2}.join(" ")

    if search_for.length > 0
      solr_result = Sunspot.search FactData, User do
        keywords search_for

        order_by sort_column, sort_direction

        paginate :page => params[:page] || 1, :per_page => row_count
      end

      # TODO: This message gets lost easily in history, what are the options?
      if solr_result.hits.count > solr_result.results.count || true
        logger.warn "[WARNING] SOLR Search index is out of sync, please run 'rake sunspot:index'"
      end

      @results = solr_result.results.delete_if {|res| res.class == FactData and FactData.invalid(res)}
      @results = @results.map do |result|
        SearchResults::SearchResultItem.for(obj: result, view: view_context)
      end
    else
      @results = []
    end
    
    respond_to do |format|
      format.html
      format.json {render json: @results}
    end
  end


  private
    def sort_column
      FactData.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
