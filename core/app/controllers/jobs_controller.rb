class JobsController < ApplicationController
  layout "general"

  load_and_authorize_resource

  def index
  end

  def show
    @jobs = Job.accessible_by current_ability
  end
end
