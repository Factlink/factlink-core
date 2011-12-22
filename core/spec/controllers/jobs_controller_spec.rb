require 'spec_helper'

describe JobsController do
  include Devise::TestHelpers
  include ControllerMethods
  
  let (:user)  {FactoryGirl.create :user}
 
  describe "GET index" do
    it "assigns all jobs as @jobs" do
      authenticate_user!(user)
      job = FactoryGirl.create :job, show: true
      
      ability.can :index, Job
      should_check_can :index, Job
      
      get :index
      assigns(:jobs).to_a.should =~ [job]
    end
  end

  describe "GET show" do
    it "assigns the requested job as @job" do
      job = FactoryGirl.create :job, show: true
      get :show, :id => job.id
      assigns(:job).should == job
    end
  end

end
