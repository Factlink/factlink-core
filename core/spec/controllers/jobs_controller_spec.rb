require 'spec_helper'

describe JobsController do
  include Devise::TestHelpers
  include ControllerMethods
  
  let (:user)  {FactoryGirl.create(:user, admin: false)}
 
  # This should return the minimal set of attributes required to create a valid
  # Job. As you add validations to Job, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    pending "assigns all jobs as @jobs" do
      authenticate_user!(user)
      @job = Job.new
      Job.stub(:new) { @job }
      should_check_can :new, @job
      job = Job.create! valid_attributes
      get :index
      assigns(:jobs).should eq([Job])
    end
  end

  describe "GET show" do
    pending "assigns the requested job as @job" do
      job = Job.create! valid_attributes
      get :show, :id => job.id
      assigns(:job).should eq(job)
    end
  end

end
