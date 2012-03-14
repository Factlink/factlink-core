require 'spec_helper'

describe FactsController do
  render_views

  let(:user) { FactoryGirl.create(:user) }

  describe :show do
    it "should render succesful" do
      @fact = FactoryGirl.create(:fact)
      @fact.created_by.user = FactoryGirl.create :user
      @fact.created_by.save
      should_check_can :show, @fact
      get :show, :id => @fact.id
      response.should be_succes
    end

    it "should render json succesful" do
      @fact = FactoryGirl.create(:fact)
      @fact.created_by.user = FactoryGirl.create :user
      @fact.created_by.save
      should_check_can :show, @fact
      get :show, id: @fact.id, format: :json
      response.should be_succes
    end
  end

  describe :extended_show do
    it "should escape html in fields" do
      @fact = FactoryGirl.create(:fact)
      @fact.data.displaystring = "baas<xss> of niet"
      @fact.data.title = "baas<xss> of niet"
      @fact.data.save

      @fact.created_by.user = FactoryGirl.create :user
      @fact.created_by.save

      should_check_can :show, @fact
      get :extended_show, :id => @fact.id, :fact_slug => 'hoi'

      response.body.should_not match(/<xss>/)
    end
  end

  describe :destroy do
    it "should delete the fact" do
      @fact = FactoryGirl.create(:fact)
      @fact.created_by.user = FactoryGirl.create :user
      @fact.created_by.save
      @fact_id = @fact.id

      should_check_can :destroy, @fact
      get :destroy, id: @fact.id, format: :json
      response.should be_succes

      Fact[@fact_id].should == nil
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
      response.should redirect_to(new_fact_path url: "http://example.org/", title: "Title")
    end

    it "should work with json" do
      authenticate_user!(user)
      should_check_can :create, anything
      post 'create', :format => :json, :url => "http://example.org/",  :displaystring => "Facity Fact", :title => "Title"
      response.code.should eq("201")
    end
  end

  describe :new do
    it "should work" do
      authenticate_user!(user)
      post 'new', :url => "http://example.org/",  :displaystring => "Facity Fact", :title => "Title"
      response.should be_succes
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
  end

end