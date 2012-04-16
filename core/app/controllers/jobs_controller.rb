class JobsController < ApplicationController
  layout "general"

  around_filter :give_404_for_invalid_id

  def give_404_for_invalid_id
    yield
  rescue BSON::InvalidObjectId
    raise_404
  end

  load_and_authorize_resource

  def index
  end

  def show
    @jobs = Job.accessible_by current_ability
  end
end
