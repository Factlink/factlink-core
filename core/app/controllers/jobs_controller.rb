class JobsController < ApplicationController
  layout "general"
  
  def index
    @jobs = Job.all
  end

  def show
    @jobs = Job.all
    @job = Job.find(params[:id])
  end
end
