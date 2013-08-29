require 'spec_helper'

describe FactsController do
  include PavlovSupport

  render_views

  let(:user) { create(:user) }

  describe :show do
    it "should render successful" do
      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end

      ability.stub(:can?).with(:show, Fact).and_return(true)
      ability.stub(:can?).with(:share_to, :twitter).and_return(false)
      ability.stub(:can?).with(:share_to, :facebook).and_return(false)
      should_check_can :show, fact

      get :show, id: fact.id
      response.should be_success
    end

    it "should render json successful" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check

      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
        fact.add_opinion :believes, user.graph_user
      end
      FactGraph.recalculate

      ability.should_receive(:can?).with(:show, Fact).and_return(true)
      should_check_can :show, fact

      get :show, id: fact.id, format: :json
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'facts#show should keep the same content')
    end

    it "should render json successful for non-logged in users" do
      Timecop.freeze Time.local(1995, 4, 30, 15, 35, 45)
      FactoryGirl.reload # hack because of fixture in check

      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
        fact.add_opinion :believes, user.graph_user
      end
      FactGraph.recalculate

      ability.should_receive(:can?).with(:show, Fact).and_return(true)
      should_check_can :show, fact

      get :show, id: fact.id, format: :json
      response.should be_success

      response_body = response.body.to_s
      # strip mongo id, since otherwise comparison will always fail
      response_body.gsub!(/"id":\s*"[^"]*"/, '"id": "<STRIPPED>"')
      Approvals.verify(response_body, format: :json, name: 'facts#show should keep the same content for anonymous')
    end
  end

  describe :discussion_page do
    it "should escape html in fields" do
      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end

      fact.data.displaystring = "baas<xss> of niet"
      fact.data.title = "baas<xss> of niet"
      fact.data.save

      ability.stub can?: true
      should_check_can :access, Ability::FactlinkWebapp
      should_check_can :show, fact

      get :discussion_page, id: fact.id, fact_slug: 'hoi'
      response.body.should_not match(/<xss>/)
    end
  end

  describe :destroy do
    it "should delete the fact" do
      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end
      fact_id = fact.id

      ability.should_receive(:can?).with(:show, Fact).and_return(true)
      should_check_can :destroy, fact
      get :destroy, id: fact.id, format: :json
      response.should be_success

      Fact[fact_id].should == nil
    end
  end

  describe :intermediate do
    it "should have the correct assignments" do
      subject.stub(:current_user) {user}
      post :intermediate, the_action: "prepare"
      response.code.should eq("200")
    end
  end

  describe :create do
    it "should work with json" do
      authenticate_user!(user)
      post 'create', format: :json, url: "http://example.org/", fact: "Facity Fact", title: "Title"
      response.code.should eq("200")
    end
    it "should work with json, with initial belief" do
      authenticate_user!(user)
      post 'create', format: :json, url: "http://example.org/", fact: "Facity Fact", title: "Title", :opinion => :believes
      response.code.should eq("200")
    end
  end

  describe :new do
    it "should work" do
      authenticate_user!(user)
      post 'new', url: "http://example.org/", displaystring: "Facity Fact", title: "Title"
      response.should be_success
    end
  end

  describe :evidence_search do
    it "should work" do
      authenticate_user!(user)
      fact = nil

      as(user) do |pavlov|
        fact = pavlov.interactor(:'facts/create',
                                     displaystring: 'displaystring',
                                     url: 'url',
                                     title: 'title',
                                     sharing_options: {})
      end

      get :evidence_search, id: fact.id, s: "Baron"
      response.should be_success
    end
  end
end
