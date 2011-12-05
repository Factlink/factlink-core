require 'spec_helper'

describe FactsController do
  include Devise::TestHelpers
  include ControllerMethods
  render_views

  let(:user) { FactoryGirl.create(:user) }

  before do
    get_ability
  end

  describe :show do
    pending "should render succesful" do
      @fact = FactoryGirl.create(:fact)
      @fact.created_by.user = FactoryGirl.create :user
      @fact.created_by.save
      should_check_can :show, @fact
      get :show, :id => @fact.id
      response.should be_succes
    end
    
    pending "should escape html in fields" do
      @fact = FactoryGirl.create(:fact)
      @fact.data.displaystring = "baas<xss> of niet"
      @fact.data.title = "baas<xss> of niet"
      @fact.data.save

      @fact.created_by.user = FactoryGirl.create :user
      @fact.created_by.save
      
      should_check_can :show, @fact
      get :show, :id => @fact.id
      
      response.body.should_not match(/<xss>/)
    end
  end

  describe :intermediate do
    it "should have the correct assignments" do
      post :intermediate, :the_action => "prepare"
      response.code.should eq("200")
    end
  end

  describe :create do
    it "should work" do
      authenticate_user!(user)
      should_check_can :create, anything
      post 'create', :url => "http://example.org/",  :displaystring => "Facity Fact", :title => "Title"
      response.should redirect_to(created_fact_path(Fact.all.to_a.last.id))
    end
    
    it "should work with json" do
      authenticate_user!(user)
      should_check_can :create, anything
      post 'create', :format => :json, :url => "http://example.org/",  :displaystring => "Facity Fact", :title => "Title"
      response.code.should eq("201")
    end
  end

  describe "adding evidence" do
    before do
      @fact = FactoryGirl.create(:fact)
      @fact.created_by.user = FactoryGirl.create :user
      @fact.created_by.save
      
      @evidence = FactoryGirl.create :fact
      @evidence.created_by.user = FactoryGirl.create :user
      @evidence.created_by.save
    end

    describe :add_supporting_evidence do
      it "should respond to XHR" do
        authenticate_user!(user)
        should_check_can :add_evidence, @fact
        xhr :get, :add_supporting_evidence,
          :id => @fact.id,
          :evidence_id => @evidence.id

        response.code.should eq("200")
      end
    
    end

    describe :add_weakening_evidence do
      it "should respond to XHR" do
        authenticate_user!(user)
        should_check_can :add_evidence, @fact
        xhr :get, :add_supporting_evidence,
          :id => @fact.id,
          :evidence_id => @evidence.id

        response.code.should eq("200")
      end
    end
  end

end