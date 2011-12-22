class AdminController < ApplicationController
  def require_admin_access
    authorize! :access, Ability::AdminArea
  end
  before_filter :require_admin_access
end