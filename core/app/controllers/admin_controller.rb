class AdminController < ApplicationController
  layout "admin"

  before_filter :require_admin_access
  before_filter :authenticate_user!

  def require_admin_access
    authorize! :access, Ability::AdminArea
  end

  # GET /a/info
  def info
    @info = Rails::Info.to_html
  end

  # GET /a/cause_error
  def cause_error
    raise 'This is an intentional error'
  end

  # GET /a/cleanup_feed
  def cleanup_feed
    Resque.enqueue CleanupActivitiesWorker
    flash[:notice] = "Scheduled Clean invalid activities"
    redirect_to request.env["HTTP_REFERER"]
  end

  # GET /a/remove_empty_facts
  def remove_empty_facts
    Resque.enqueue CleanupFactsWithoutInteraction
    flash[:notice] = "Scheduled Remov facts without interaction"
    redirect_to request.env["HTTP_REFERER"]
  end

  before_filter :set_cache_buster
  def set_cache_buster
     response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
     response.headers["Pragma"] = "no-cache"
     response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
