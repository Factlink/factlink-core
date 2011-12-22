class Admin::JobsController < AdminController
  layout "admin"

  load_and_authorize_resource


  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @job.save
      redirect_to admin_jobs_url, notice: 'Job was successfully created.'
    else
      render :new
    end
  end

  def update
    if @job.update_attributes(params[:job])
      redirect_to admin_jobs_url, notice: 'Job was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    redirect_to admin_jobs_url
  end


end
