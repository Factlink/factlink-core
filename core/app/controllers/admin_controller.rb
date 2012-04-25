class AdminController < ApplicationController
  before_filter :require_admin_access
  def require_admin_access
    authorize! :access, Ability::AdminArea
  end

  before_filter :set_cache_buster
  def set_cache_buster
     response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
     response.headers["Pragma"] = "no-cache"
     response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end