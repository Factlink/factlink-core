require 'spec_helper'

describe Admin::JobsController do
  include Devise::TestHelpers
  include ControllerMethods
  
  let (:admin) {FactoryGirl.create(:user, admin: true)}
  let (:user)  {FactoryGirl.create(:user, admin: false)}
  let (:job)   {FactoryGirl.create :job}
  
  # This should return the minimal set of attributes required to create a valid
  # Job. As you add validations to Job, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  before do
    should_check_admin_ability
  end
  
  describe "GET new" do
    it "assigns a new job as @job" do
      authenticate_user!(user)
      @job = Job.new
      Job.stub(:new) { @job }
      should_check_can :new, @job
      get :new
      assigns(:job).should be_a_new(Job)
    end
  end

  describe "GET edit" do
    it "assigns the requested job as @job" do
      authenticate_user!(user)
      should_check_can :edit, job
      get :edit, :id => job.id
      assigns(:job).should eq(job)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Job" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :create, @job
        expect {
          post :create, :job => valid_attributes
        }.to change(Job, :count).by(1)
      end

      it "assigns a newly created job as @job" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :create, @job

        post :create, :job => valid_attributes
        assigns(:job).should be_a(Job)
        assigns(:job).should be_persisted
      end

      it "redirects to the index" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :create, @job
        post :create, :job => valid_attributes
        response.should redirect_to(admin_jobs_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job as @job" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :create, @job

        Job.any_instance.stub(:save).and_return(false)
        post :create, :job => {}
        assigns(:job).should be_a_new(Job)
      end

      it "re-renders the 'new' template" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :create, @job

        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        post :create, :job => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested job" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :update, @job

        job = Job.create! valid_attributes
        # Assuming there are no other jobs in the database, this
        # specifies that the Job created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Job.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => job.id, :job => {'these' => 'params'}
      end

      it "assigns the requested job as @job" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :update, @job

        job = Job.create! valid_attributes
        put :update, :id => job.id, :job => valid_attributes
        assigns(:job).should eq(job)
      end

      it "redirects to the job" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :update, @job

        job = Job.create! valid_attributes
        put :update, :id => job.id, :job => valid_attributes
        response.should redirect_to(admin_jobs_url)
      end
    end

    describe "with invalid params" do
      it "assigns the job as @job" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :update, @job

        job = Job.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        put :update, :id => job.id, :job => {}
        assigns(:job).should eq(job)
      end

      it "re-renders the 'edit' template" do
        authenticate_user!(user)
        @job = Job.new
        Job.stub(:new) { @job }
        should_check_can :update, @job

        job = Job.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        put :update, :id => job.id, :job => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested job" do
      authenticate_user!(user)
      @job = Job.new
      Job.stub(:new) { @job }
      should_check_can :destroy, @job
        
      job = Job.create! valid_attributes
      expect {
        delete :destroy, :id => job.id
      }.to change(Job, :count).by(-1)
    end

    it "redirects to the jobs list" do
      authenticate_user!(user)
      @job = Job.new
      Job.stub(:new) { @job }
      should_check_can :destroy, @job
      
      job = Job.create! valid_attributes
      delete :destroy, :id => job.id
      response.should redirect_to(admin_jobs_url)
    end
  end
end
