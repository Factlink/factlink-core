require 'spec_helper'

describe JobsController do

  # This should return the minimal set of attributes required to create a valid
  # Job. As you add validations to Job, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all jobs as @jobs" do
      job = Job.create! valid_attributes
      get :index
      assigns(:jobs).should eq([job])
    end
  end

  describe "GET show" do
    it "assigns the requested job as @job" do
      job = Job.create! valid_attributes
      get :show, :id => job.id
      assigns(:job).should eq(job)
    end
  end

end
